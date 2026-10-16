import Foundation

/// Finalizes already-closed audio files without deleting a usable mic track.
enum RecordingFiles {
    static func destination(in directory: URL, at date: Date = Date()) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        var candidateDate = date
        while true {
            let base = directory.appendingPathComponent(formatter.string(from: candidateDate))
            let extensions = ["wav", "mic.wav", "sync", "meta", "notes"]
            if !extensions.contains(where: { FileManager.default.fileExists(atPath: base.appendingPathExtension($0).path) }) {
                return base.appendingPathExtension("wav")
            }
            // Keep the timestamp filename contract while avoiding an existing recording.
            candidateDate = candidateDate.addingTimeInterval(1)
        }
    }

    static func finalize(expectedURL: URL, system: (url: URL?, startedAt: Double?),
                         microphone: (url: URL, firstBufferAt: Double)?,
                         log: (String) -> Void = { _ in }) -> URL? {
        var savedURL = system.url
        var systemStart = system.startedAt
        if savedURL == nil, let microphone {
            do {
                if FileManager.default.fileExists(atPath: expectedURL.path) {
                    let size = (try FileManager.default.attributesOfItem(atPath: expectedURL.path)[.size] as? Int) ?? 0
                    guard size <= 1024 else {
                        log("Refusing to overwrite existing primary audio: \(expectedURL.path); mic preserved")
                        return nil
                    }
                    try FileManager.default.removeItem(at: expectedURL)
                }
                try FileManager.default.copyItem(at: microphone.url, to: expectedURL)
                savedURL = expectedURL
                systemStart = microphone.firstBufferAt
                log("Capture saved from microphone only: \(expectedURL.lastPathComponent)")
            } catch {
                log("Could not create primary WAV; microphone preserved at \(microphone.url.path): \(error.localizedDescription)")
            }
        }
        guard let savedURL else {
            log("Capture ended without a primary WAV: \(expectedURL.lastPathComponent)")
            return nil
        }
        if let microphone, let systemStart {
            let offset = microphone.firstBufferAt - systemStart
            let body = "mic_file: \(microphone.url.lastPathComponent)\nmic_offset_seconds: \(String(format: "%.3f", offset))\n"
            do {
                try body.write(to: savedURL.deletingPathExtension().appendingPathExtension("sync"),
                               atomically: true, encoding: .utf8)
            } catch { log("Could not save sync sidecar: \(error.localizedDescription)") }
        }
        log("Capture saved: \(savedURL.lastPathComponent); mic: \(microphone?.url.lastPathComponent ?? "unavailable")")
        return savedURL
    }
}
