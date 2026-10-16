import Foundation
import Testing
@testable import RecordBot

@Suite struct RecordingFilesTests {
    private func directory() throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("RecordingFilesTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    @Test func emptySystemPreservesUsableMicrophoneAndCreatesQueuedPrimary() throws {
        let folder = try directory()
        defer { try? FileManager.default.removeItem(at: folder) }
        let primary = folder.appendingPathComponent("meeting.wav")
        let mic = folder.appendingPathComponent("meeting.mic.wav")
        let micBytes = Data(repeating: 1, count: 4096)
        try micBytes.write(to: mic)
        let result = RecordingFiles.finalize(expectedURL: primary, system: (nil, nil), microphone: (mic, 50))
        #expect(result == primary)
        #expect(try Data(contentsOf: primary) == micBytes)
        #expect(try Data(contentsOf: mic) == micBytes)
        #expect(try String(contentsOf: folder.appendingPathComponent("meeting.sync"), encoding: .utf8).contains("mic_offset_seconds: 0.000"))
    }

    @Test func interruptedRecordingKeepsBothFilesAndSync() throws {
        let folder = try directory()
        defer { try? FileManager.default.removeItem(at: folder) }
        let primary = folder.appendingPathComponent("meeting.wav")
        let mic = folder.appendingPathComponent("meeting.mic.wav")
        let original = Data(repeating: 1, count: 4096)
        let microphone = Data(repeating: 2, count: 2048)
        try original.write(to: primary)
        try microphone.write(to: mic)
        #expect(RecordingFiles.finalize(expectedURL: primary, system: (primary, 50), microphone: (mic, 50.123)) == primary)
        #expect(try Data(contentsOf: primary) == original)
        #expect(try Data(contentsOf: mic) == microphone)
        #expect(try String(contentsOf: folder.appendingPathComponent("meeting.sync"), encoding: .utf8).contains("mic_offset_seconds: 0.123"))
    }

    @Test func failedMicFallbackDoesNotDeleteMicrophoneOrOverwriteExistingAudio() throws {
        let folder = try directory()
        defer { try? FileManager.default.removeItem(at: folder) }
        let primary = folder.appendingPathComponent("existing.wav")
        let mic = folder.appendingPathComponent("meeting.mic.wav")
        let original = Data(repeating: 1, count: 4096)
        let microphone = Data(repeating: 2, count: 2048)
        try original.write(to: primary)
        try microphone.write(to: mic)
        #expect(RecordingFiles.finalize(expectedURL: primary, system: (nil, nil), microphone: (mic, 50)) == nil)
        #expect(try Data(contentsOf: primary) == original)
        #expect(try Data(contentsOf: mic) == microphone)
    }

    @Test func destinationAvoidsExistingSystemAndOrphanMicFiles() throws {
        let folder = try directory()
        defer { try? FileManager.default.removeItem(at: folder) }
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let first = RecordingFiles.destination(in: folder, at: date)
        try Data([1]).write(to: first.deletingPathExtension().appendingPathExtension("mic.wav"))
        let second = RecordingFiles.destination(in: folder, at: date)
        #expect(second != first)
        try Data([2]).write(to: second)
        let third = RecordingFiles.destination(in: folder, at: date)
        #expect(third != first)
        #expect(third != second)
    }
}
