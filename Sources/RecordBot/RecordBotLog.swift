import Foundation
import Darwin

/// Persistent capture and UI events, alongside the processing pipeline log.
enum RecordBotLog {
    private static let lock = NSLock()
    private static var destination: URL?

    static func configure(_ url: URL) {
        lock.lock(); defer { lock.unlock() }
        destination = url
    }

    static func write(_ message: String) {
        NSLog("RecordBot: %@", message)
        lock.lock(); defer { lock.unlock() }
        guard let destination else { return }
        let formatter = ISO8601DateFormatter()
        let line = "[\(formatter.string(from: Date()))] APP \(message)\n"
        guard let data = line.data(using: .utf8) else { return }
        // O_APPEND keeps each event intact while transcription processes append
        // to this same log. Seeking a FileHandle to EOF would race their writes.
        let descriptor = Darwin.open(destination.path, O_WRONLY | O_CREAT | O_APPEND, S_IRUSR | S_IWUSR)
        guard descriptor >= 0 else {
            NSLog("RecordBot: persistent log open failed: %d", errno)
            return
        }
        defer { Darwin.close(descriptor) }
        data.withUnsafeBytes { bytes in
            guard let address = bytes.baseAddress else { return }
            var offset = 0
            while offset < bytes.count {
                let written = Darwin.write(descriptor, address.advanced(by: offset), bytes.count - offset)
                if written < 0 {
                    if errno == EINTR { continue }
                    NSLog("RecordBot: persistent log write failed: %d", errno)
                    break
                }
                if written == 0 { break }
                offset += written
            }
        }
    }
}
