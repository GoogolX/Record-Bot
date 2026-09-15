import AVFoundation
import Foundation
import QuartzCore

/// Records your own microphone to its own file, alongside the system audio capture.
///
/// Two tracks rather than one mix, for two reasons. Your voice is loud in the mic and
/// absent from the call audio, which identifies your own speaker cluster by arithmetic
/// instead of guesswork. And a close-talking mic transcribes better than your voice
/// after it has been through a conferencing codec and back.
final class MicRecorder {

    private let engine = AVAudioEngine()
    private let lock = NSLock()
    private var file: AVAudioFile?
    private var destination: URL?
    private var firstBufferAt: Double?
    private var warnedAboutFormat = false
    private var configObserver: NSObjectProtocol?

    /// Starts capture. Throws if there is no usable input device.
    func start(writingTo url: URL) throws {
        // Idempotent: installing a second tap on an already-tapped bus raises an
        // ObjC exception that no Swift catch can see, which would take the app down.
        teardownEngine()

        let input = engine.inputNode
        // The tap validates against the node's OUTPUT bus, not the hardware input
        // format. Those differ on aggregate devices and multi-channel interfaces,
        // and a mismatch is an uncatchable exception rather than a thrown error.
        let format = input.outputFormat(forBus: 0)

        guard format.sampleRate > 0, format.channelCount > 0 else {
            throw NSError(
                domain: "RecordBot",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "No microphone input is available."]
            )
        }

        let target = try AVAudioFile(
            forWriting: url,
            settings: [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVSampleRateKey: format.sampleRate,
                AVNumberOfChannelsKey: Int(format.channelCount),
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsNonInterleaved: false
            ]
        )

        lock.lock()
        file = target
        destination = url
        firstBufferAt = nil
        warnedAboutFormat = false
        lock.unlock()

        input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            guard let self else { return }

            self.lock.lock()
            if self.firstBufferAt == nil { self.firstBufferAt = CACurrentMediaTime() }
            let sink = self.file
            let alreadyWarned = self.warnedAboutFormat
            self.lock.unlock()

            guard let sink else { return }

            // Writing a mismatched format raises an ObjC exception rather than
            // throwing, so it has to be checked. Say so once when it happens,
            // otherwise a silently empty mic track is unexplainable later.
            guard buffer.format == sink.processingFormat else {
                if !alreadyWarned {
                    self.lock.lock()
                    self.warnedAboutFormat = true
                    self.lock.unlock()
                    NSLog("RecordBot: mic format \(buffer.format) does not match file \(sink.processingFormat), mic track disabled")
                }
                return
            }

            do {
                try sink.write(from: buffer)
            } catch {
                NSLog("RecordBot: mic write failed: \(error.localizedDescription)")
            }
        }

        // Unplugging headphones or switching input mid-meeting tears down the graph.
        // Stop cleanly rather than leaving a stale tap behind for the next recording.
        let observer = NotificationCenter.default.addObserver(
            forName: .AVAudioEngineConfigurationChange,
            object: engine,
            queue: nil
        ) { [weak self] _ in
            NSLog("RecordBot: audio device changed, mic track ends here")
            self?.teardownEngine()
        }
        lock.lock()
        configObserver = observer
        lock.unlock()

        engine.prepare()
        try engine.start()
    }

    /// Stops capture. Returns the file and the moment its first sample landed,
    /// or nil when nothing usable was recorded.
    func stop() -> (url: URL, firstBufferAt: Double)? {
        teardownEngine()

        lock.lock()
        let url = destination
        let started = firstBufferAt
        file = nil
        destination = nil
        firstBufferAt = nil
        lock.unlock()

        guard let url else { return nil }

        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        let size = (attributes?[.size] as? Int) ?? 0
        guard let started, size > 1024 else {
            try? FileManager.default.removeItem(at: url)
            return nil
        }
        return (url, started)
    }

    /// Removes the tap and stops the engine. Safe to call when nothing is running,
    /// and safe to call twice: the device-change notification and an ordinary stop
    /// can race.
    private func teardownEngine() {
        lock.lock()
        let observer = configObserver
        configObserver = nil
        lock.unlock()

        if let observer { NotificationCenter.default.removeObserver(observer) }
        engine.inputNode.removeTap(onBus: 0)
        if engine.isRunning { engine.stop() }
    }
}
