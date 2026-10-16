import AVFoundation
import Foundation

/// Owns one system-audio output session. Call all methods on the same serial
/// queue used for sample-buffer delivery so AVAudioFile and converter access is
/// confined to that queue.
final class RecordingOutput {
    enum OutputError: LocalizedError {
        case staleSession
        case converterUnavailable
        case conversionFailed(String)

        var errorDescription: String? {
            switch self {
            case .staleSession:
                return "Audio arrived for an inactive recording session."
            case .converterUnavailable:
                return "Could not create an audio format converter."
            case .conversionFailed(let reason):
                return "Audio conversion failed: \(reason)"
            }
        }
    }

    private let log: (String) -> Void
    private var activeSession: ObjectIdentifier?
    private var activeURL: URL?
    private var audioFile: AVAudioFile?
    private var converter: AVAudioConverter?
    private var startedAt: Double?

    init(log: @escaping (String) -> Void = { NSLog("RecordBot: %@", $0) }) {
        self.log = log
    }

    /// Resets any previous output and makes `url` current before capture starts.
    /// The WAV is opened lazily on the first buffer, when its input format is known.
    func begin(session: ObjectIdentifier, url: URL) {
        audioFile = nil
        converter = nil
        startedAt = nil
        activeURL = url
        activeSession = session
    }

    /// Writes a buffer only when it belongs to the current active session.
    func write(_ pcm: AVAudioPCMBuffer, session: ObjectIdentifier, at time: Double) throws {
        guard activeSession == session, let url = activeURL else {
            throw OutputError.staleSession
        }

        if startedAt == nil { startedAt = time }

        if audioFile == nil {
            do {
                audioFile = try AVAudioFile(
                    forWriting: url,
                    settings: [
                        AVFormatIDKey: kAudioFormatLinearPCM,
                        AVSampleRateKey: pcm.format.sampleRate,
                        AVNumberOfChannelsKey: Int(pcm.format.channelCount),
                        AVLinearPCMBitDepthKey: 16,
                        AVLinearPCMIsFloatKey: false,
                        AVLinearPCMIsBigEndianKey: false,
                        AVLinearPCMIsNonInterleaved: false
                    ]
                )
            } catch {
                log("could not open \(url.lastPathComponent): \(error.localizedDescription)")
                throw error
            }
        }

        guard let file = audioFile else { return }
        if pcm.format == file.processingFormat {
            try file.write(from: pcm)
            return
        }

        if converter == nil || converter?.inputFormat != pcm.format || converter?.outputFormat != file.processingFormat {
            converter = AVAudioConverter(from: pcm.format, to: file.processingFormat)
            log("format changed to \(pcm.format), converting to \(file.processingFormat)")
        }
        guard let converter else { throw OutputError.converterUnavailable }

        let ratio = file.processingFormat.sampleRate / pcm.format.sampleRate
        let outputCapacity = AVAudioFrameCount(Double(pcm.frameLength) * ratio + 512)
        guard let convertedBuffer = AVAudioPCMBuffer(
            pcmFormat: file.processingFormat,
            frameCapacity: outputCapacity
        ) else {
            throw OutputError.converterUnavailable
        }

        var conversionError: NSError?
        var consumed = false
        let status = converter.convert(to: convertedBuffer, error: &conversionError) { _, inputStatus in
            if !consumed {
                consumed = true
                inputStatus.pointee = .haveData
                return pcm
            }
            inputStatus.pointee = .noDataNow
            return nil
        }
        if status == .error || conversionError != nil {
            let reason = conversionError?.localizedDescription ?? "converter returned an error status"
            throw OutputError.conversionFailed(reason)
        }
        if convertedBuffer.frameLength > 0 {
            try file.write(from: convertedBuffer)
        }
    }

    /// Closes and clears the matching session. A stale finish is a no-op and
    /// cannot close the output of a newer recording.
    func finish(session: ObjectIdentifier) -> (url: URL?, startedAt: Double?) {
        guard activeSession == session else { return (nil, nil) }

        let url = activeURL
        let firstBufferAt = startedAt
        audioFile = nil
        converter = nil
        activeURL = nil
        activeSession = nil
        startedAt = nil

        guard let url,
              let size = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int,
              size > 1024 else {
            return (nil, firstBufferAt)
        }
        return (url, firstBufferAt)
    }
}
