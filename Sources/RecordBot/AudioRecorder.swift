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
        case interrupted

        var errorDescription: String? {
            switch self {
            case .noDisplay:
                return "No display available to attach the audio stream to."
            case .alreadyRecording:
                return "A recording is already running."
            case .interrupted:
                return "The audio stream was interrupted while starting."
            }
        }
    }

    /// Posted when the stream dies on its own rather than by request, so the UI can reset.
    static let streamDied = Notification.Name("com.recordbot.streamDied")

    private let writeQueue = DispatchQueue(label: "com.recordbot.audiowrite")
    private let videoSinkQueue = DispatchQueue(label: "com.recordbot.videosink")
    private let lock = NSLock()
    private let mic = MicRecorder()

    // Lifecycle fields are guarded by `lock`; output is confined to writeQueue.
    private var stream: SCStream?
    private let output = RecordingOutput(log: RecordBotLog.write)
    private var captureURL: URL?
    private var recording = false
    private var starting = false
    private var stopping = false

    var isRecording: Bool {
        lock.lock(); defer { lock.unlock() }
        return recording
    }

    /// Starts capture, writing to a timestamped WAV inside `directory`. Returns the destination.
    @discardableResult
    func start(in directory: URL) async throws -> URL {
        try reserveStart()
        defer { finishStarting() }

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
        let url = RecordingFiles.destination(in: directory)

        let newStream = SCStream(filter: filter, configuration: config, delegate: self)
        try newStream.addStreamOutput(self, type: .screen, sampleHandlerQueue: videoSinkQueue)
        try newStream.addStreamOutput(self, type: .audio, sampleHandlerQueue: writeQueue)
        // ScreenCaptureKit can deliver audio before startCapture() returns.
        // Install the new destination first, and accept only this stream's buffers.
        prepareCapture(stream: newStream, url: url)
        RecordBotLog.write("Capture starting: \(url.lastPathComponent)")
        do {
            try await newStream.startCapture()
        } catch {
            if let capture = takeStreamForStop(matching: newStream) {
                _ = finishCapture(capture, micResult: mic.stop())
            }
            throw error
        }
        guard activateCapture(newStream) else { throw RecorderError.interrupted }
        RecordBotLog.write("Capture started: \(url.lastPathComponent)")
        return url
    }

    private func reserveStart() throws {
        lock.lock(); defer { lock.unlock() }
        guard !recording, !starting, !stopping else { throw RecorderError.alreadyRecording }
        starting = true
    }

    private func finishStarting() {
        lock.lock(); defer { lock.unlock() }
        starting = false
    }

    private func prepareCapture(stream newStream: SCStream, url: URL) {
        writeQueue.sync { output.begin(session: ObjectIdentifier(newStream), url: url) }
        lock.lock(); defer { lock.unlock() }
        stream = newStream
        captureURL = url
    }

    private func activateCapture(_ newStream: SCStream) -> Bool {
        lock.lock(); defer { lock.unlock() }
        guard stream === newStream, let url = captureURL, !stopping else { return false }
        // Serialize mic start with interruption handling, so an interrupted stream
        // cannot stop the mic just before a late start installs a fresh tap.
        do {
            try mic.start(writingTo: url.deletingPathExtension().appendingPathExtension("mic.wav"))
        } catch {
            RecordBotLog.write("Microphone unavailable for \(url.lastPathComponent): \(error.localizedDescription)")
        }
        recording = true
        return true
    }

    private typealias Capture = (stream: SCStream, url: URL)

    private func takeStreamForStop(matching expected: SCStream? = nil) -> Capture? {
        lock.lock(); defer { lock.unlock() }
        guard let live = stream, let url = captureURL,
              expected == nil || live === expected else { return nil }
        stream = nil
        captureURL = nil
        recording = false
        stopping = true
        return (live, url)
    }

    private func finishStopping() {
        lock.lock(); defer { lock.unlock() }
        stopping = false
    }

    /// Drain queued samples and finalize both files before allowing another start.
    @discardableResult
    func stop() async -> URL? {
        guard let capture = takeStreamForStop() else { return nil }
        let micResult = mic.stop()
        do { try await capture.stream.stopCapture() }
        catch { RecordBotLog.write("Stop capture failed: \(error.localizedDescription)") }
        return finishCapture(capture, micResult: micResult)
    }

    private func finishCapture(_ capture: Capture, micResult: (url: URL, firstBufferAt: Double)?) -> URL? {
        let closed = writeQueue.sync { output.finish(session: ObjectIdentifier(capture.stream)) }
        let saved = finalizeFiles(expectedURL: capture.url, closed: closed, micResult: micResult)
        finishStopping()
        return saved
    }

    private func finalizeFiles(expectedURL: URL, closed: (url: URL?, startedAt: Double?),
                               micResult: (url: URL, firstBufferAt: Double)?) -> URL? {
        RecordingFiles.finalize(expectedURL: expectedURL, system: closed, microphone: micResult,
                                log: RecordBotLog.write)
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

                try output.write(pcm, session: ObjectIdentifier(stream), at: CACurrentMediaTime())
            }
        } catch RecordingOutput.OutputError.staleSession {
            // Late buffers from a stopped stream are expected and must be ignored.
        } catch {
            RecordBotLog.write("Audio write failed: \(error.localizedDescription)")
        }
    }

    // MARK: - SCStreamDelegate

    func stream(_ stream: SCStream, didStopWithError error: Error) {
        // A delayed error from an older stream must not end a newer recording.
        guard let capture = takeStreamForStop(matching: stream) else { return }
        RecordBotLog.write("Capture interrupted: \(capture.url.lastPathComponent): \(error.localizedDescription)")
        let micResult = mic.stop()
        writeQueue.async {
            let closed = self.output.finish(session: ObjectIdentifier(capture.stream))
            let saved = self.finalizeFiles(expectedURL: capture.url, closed: closed, micResult: micResult)
            self.finishStopping()
            DispatchQueue.main.async {
                var info: [String: Any] = ["reason": error.localizedDescription]
                if let saved { info["recordingURL"] = saved }
                NotificationCenter.default.post(name: Self.streamDied, object: self, userInfo: info)
            }
        }
    }

}
