import AVFoundation
import Foundation
import QuartzCore
import ScreenCaptureKit

/// Captures system audio (everything you hear: Zoom, Meet, Slack huddles, browser tabs)
/// using ScreenCaptureKit and writes it to a WAV file.
///
/// ScreenCaptureKit insists on a display-based content filter even when only audio is
/// wanted, and a stream that produces video frames with nobody consuming them tends to
/// stall, so a tiny screen output is registered and its buffers are dropped on arrival.
final class AudioRecorder: NSObject, SCStreamOutput, SCStreamDelegate {

    enum RecorderError: LocalizedError {
        case noDisplay
        case alreadyRecording

        var errorDescription: String? {
            switch self {
            case .noDisplay:
                return "No display available to attach the audio stream to."
            case .alreadyRecording:
                return "A recording is already running."
            }
        }
    }

    /// Posted when the stream dies on its own rather than by request, so the UI can reset.
    static let streamDied = Notification.Name("com.recordbot.streamDied")

    private let writeQueue = DispatchQueue(label: "com.recordbot.audiowrite")
    private let videoSinkQueue = DispatchQueue(label: "com.recordbot.videosink")
    private let lock = NSLock()
    private let mic = MicRecorder()

    // All of these are guarded by `lock`, including the reads inside the sample callback.
    private var stream: SCStream?
    private var audioFile: AVAudioFile?
    private var converter: AVAudioConverter?
    private var currentURL: URL?
    private var recording = false
    private var starting = false
    private var systemFirstBufferAt: Double?

    var isRecording: Bool {
        lock.lock(); defer { lock.unlock() }
        return recording
    }

    /// Starts capture, writing to a timestamped WAV inside `directory`. Returns the destination.
    @discardableResult
    func start(in directory: URL) async throws -> URL {
        lock.lock()
        guard !recording, !starting else {
            lock.unlock()
            throw RecorderError.alreadyRecording
        }
        starting = true
        lock.unlock()
        
        defer {
            lock.lock()
            starting = false
            lock.unlock()
        }

        let content = try await SCShareableContent.excludingDesktopWindows(
            false,
            onScreenWindowsOnly: true
        )
        guard let display = content.displays.first else { throw RecorderError.noDisplay }

        let filter = SCContentFilter(display: display, excludingApplications: [], exceptingWindows: [])

        let config = SCStreamConfiguration()
        config.capturesAudio = true
        config.excludesCurrentProcessAudio = true
        config.sampleRate = 48_000
        config.channelCount = 2
        // Minimal video: we are obliged to ask for pixels, not to look at them.
        config.width = 16
        config.height = 16
        config.minimumFrameInterval = CMTime(value: 1, timescale: 1)
        config.queueDepth = 6

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("\(Self.timestamp()).wav")

        let newStream = SCStream(filter: filter, configuration: config, delegate: self)
        try newStream.addStreamOutput(self, type: .screen, sampleHandlerQueue: videoSinkQueue)
        try newStream.addStreamOutput(self, type: .audio, sampleHandlerQueue: writeQueue)
        try await newStream.startCapture()

        // Only claim the URL once capture is actually live, so a failed start leaves no trace.
        commitStart(stream: newStream, url: url)

        // Your own mic, on its own track. Best effort: a denied permission or a
        // machine with no input device should not stop the meeting being recorded.
        do {
            try mic.start(writingTo: url.deletingPathExtension().appendingPathExtension("mic.wav"))
        } catch {
            NSLog("RecordBot: microphone unavailable, recording system audio only: \(error.localizedDescription)")
        }

        return url
    }

    /// Locking helpers are deliberately synchronous: NSLock must not be held across a suspension.
    private func commitStart(stream newStream: SCStream, url: URL) {
        lock.lock()
        stream = newStream
        currentURL = url
        recording = true
        systemFirstBufferAt = nil
        lock.unlock()
    }

    private func takeStreamForStop() -> SCStream? {
        lock.lock()
        let live = stream
        stream = nil
        recording = false
        lock.unlock()
        return live
    }

    /// Stops capture and returns the finished WAV, or nil if nothing usable was captured.
    @discardableResult
    func stop() async -> URL? {
        // Mic first, unconditionally: if the system stream already died on its own,
        // the guard below returns early and the tap would be left installed, which
        // makes the next recording's installTap raise an uncatchable exception.
        let micResult = mic.stop()

        guard let live = takeStreamForStop() else {
            if let micResult { try? FileManager.default.removeItem(at: micResult.url) }
            return nil
        }
        try? await live.stopCapture()

        // Close the file on the queue that writes to it, so the last buffer lands first.
        let closed: (url: URL?, startedAt: Double?) = writeQueue.sync {
            self.lock.lock()
            let finished = self.currentURL
            let started = self.systemFirstBufferAt
            self.audioFile = nil
            self.converter = nil
            self.currentURL = nil
            self.systemFirstBufferAt = nil
            self.lock.unlock()
            return (finished, started)
        }

        guard let url = closed.url,
              let size = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int,
              size > 1024 else {
            if let url = closed.url { try? FileManager.default.removeItem(at: url) }
            if let mic = micResult { try? FileManager.default.removeItem(at: mic.url) }
            return nil
        }

        writeSyncFile(for: url, systemStart: closed.startedAt, mic: micResult)
        return url
    }

    /// Both tracks are captured by this process, so alignment is bookkeeping rather than
    /// a matching problem: record how far apart their first samples landed and the
    /// transcription step can line them up.
    private func writeSyncFile(for systemURL: URL, systemStart: Double?, mic: (url: URL, firstBufferAt: Double)?) {
        guard let mic, let systemStart else { return }

        let offset = mic.firstBufferAt - systemStart
        let body = """
        mic_file: \(mic.url.lastPathComponent)
        mic_offset_seconds: \(String(format: "%.3f", offset))
        """
        let sync = systemURL.deletingPathExtension().appendingPathExtension("sync")
        try? (body + "\n").write(to: sync, atomically: true, encoding: .utf8)
    }

    // MARK: - SCStreamOutput

    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .audio, sampleBuffer.isValid, sampleBuffer.numSamples > 0 else { return }

        do {
            try sampleBuffer.withAudioBufferList { audioBufferList, _ in
                guard let asbd = sampleBuffer.formatDescription?.audioStreamBasicDescription,
                      let format = AVAudioFormat(
                        standardFormatWithSampleRate: asbd.mSampleRate,
                        channels: asbd.mChannelsPerFrame
                      ),
                      let pcm = AVAudioPCMBuffer(
                        pcmFormat: format,
                        bufferListNoCopy: audioBufferList.unsafePointer
                      )
                else { return }

                lock.lock()
                if systemFirstBufferAt == nil { systemFirstBufferAt = CACurrentMediaTime() }
                if audioFile == nil, let url = currentURL {
                    do {
                        audioFile = try AVAudioFile(
                            forWriting: url,
                            settings: [
                                AVFormatIDKey: kAudioFormatLinearPCM,
                                AVSampleRateKey: asbd.mSampleRate,
                                AVNumberOfChannelsKey: Int(asbd.mChannelsPerFrame),
                                AVLinearPCMBitDepthKey: 16,
                                AVLinearPCMIsFloatKey: false,
                                AVLinearPCMIsBigEndianKey: false,
                                AVLinearPCMIsNonInterleaved: false
                            ]
                        )
                    } catch {
                        NSLog("RecordBot: could not open \(url.lastPathComponent): \(error.localizedDescription)")
                    }
                }
                let file = audioFile
                lock.unlock()

                // Adapt to format changes (e.g. headphone disconnects, sample rate switches)
                // rather than silently dropping audio for the remainder of the call.
                guard let file else { return }
                if pcm.format == file.processingFormat {
                    try file.write(from: pcm)
                } else {
                    lock.lock()
                    if converter == nil || converter?.inputFormat != pcm.format || converter?.outputFormat != file.processingFormat {
                        converter = AVAudioConverter(from: pcm.format, to: file.processingFormat)
                        NSLog("RecordBot: format changed to \(pcm.format), converting to \(file.processingFormat)")
                    }
                    let conv = converter
                    lock.unlock()

                    if let conv {
                        let ratio = file.processingFormat.sampleRate / pcm.format.sampleRate
                        let outputCapacity = AVAudioFrameCount(Double(pcm.frameLength) * ratio + 512)
                        if let convertedBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: outputCapacity) {
                            var error: NSError?
                            var consumed = false
                            let status = conv.convert(to: convertedBuffer, error: &error) { _, outStatus in
                                if !consumed {
                                    consumed = true
                                    outStatus.pointee = .haveData
                                    return pcm
                                } else {
                                    outStatus.pointee = .noDataNow
                                    return nil
                                }
                            }
                            if status != .error, error == nil, convertedBuffer.frameLength > 0 {
                                try file.write(from: convertedBuffer)
                            }
                        }
                    }
                }
            }
        } catch {
            NSLog("RecordBot: audio write failed: \(error.localizedDescription)")
        }
    }

    // MARK: - SCStreamDelegate

    func stream(_ stream: SCStream, didStopWithError error: Error) {
        NSLog("RecordBot: stream stopped: \(error.localizedDescription)")

        lock.lock()
        let wasRecording = recording
        recording = false
        self.stream = nil
        lock.unlock()

        // Leave no tap behind, or the next recording crashes on installTap.
        _ = mic.stop()

        writeQueue.async {
            self.lock.lock()
            self.audioFile = nil
            self.converter = nil
            self.lock.unlock()
        }

        if wasRecording {
            let name = Self.streamDied
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: name, object: nil)
            }
        }
    }

    static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: Date())
    }
}
