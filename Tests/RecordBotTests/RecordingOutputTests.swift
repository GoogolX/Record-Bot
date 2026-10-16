import AVFoundation
import Foundation
import Testing
@testable import RecordBot

@Suite struct RecordingOutputTests {
    private func fixture() throws -> (directory: URL, helper: RecordingOutput) {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("RecordingOutputTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return (directory, RecordingOutput(log: { _ in }))
    }

    @Test func interruptedSessionRemainsIntactWhenNextSessionBegins() throws {
        let (directory, helper) = try fixture()
        defer { try? FileManager.default.removeItem(at: directory) }
        let oldID = NSObject()
        let newID = NSObject()
        let oldURL = directory.appendingPathComponent("old.wav")
        let newURL = directory.appendingPathComponent("new.wav")

        helper.begin(session: ObjectIdentifier(oldID), url: oldURL)
        try helper.write(try makeBuffer(), session: ObjectIdentifier(oldID), at: 10)

        // Models a stream interruption that did not go through finish().
        helper.begin(session: ObjectIdentifier(newID), url: newURL)
        let oldBytes = try Data(contentsOf: oldURL)
        try helper.write(try makeBuffer(value: 0.25), session: ObjectIdentifier(newID), at: 20)
        let result = helper.finish(session: ObjectIdentifier(newID))

        #expect(result.url == newURL)
        #expect(result.startedAt == 20)
        #expect(try Data(contentsOf: oldURL) == oldBytes, "new capture must not overwrite old output")
        #expect(try Data(contentsOf: newURL) != oldBytes)
    }

    @Test func staleBuffersCannotRecreateOrTruncateFinalizedFile() throws {
        let (directory, helper) = try fixture()
        defer { try? FileManager.default.removeItem(at: directory) }
        let id = NSObject()
        let url = directory.appendingPathComponent("finished.wav")
        helper.begin(session: ObjectIdentifier(id), url: url)
        try helper.write(try makeBuffer(), session: ObjectIdentifier(id), at: 1)
        #expect(helper.finish(session: ObjectIdentifier(id)).url == url)
        let finalizedBytes = try Data(contentsOf: url)

        #expect(throws: RecordingOutput.OutputError.self) {
            try helper.write(try makeBuffer(value: 0.75), session: ObjectIdentifier(id), at: 2)
        }
        #expect(try Data(contentsOf: url) == finalizedBytes)
    }

    @Test func staleFinishDoesNotCloseCurrentOutput() throws {
        let (directory, helper) = try fixture()
        defer { try? FileManager.default.removeItem(at: directory) }
        let oldID = NSObject()
        let currentID = NSObject()
        let currentURL = directory.appendingPathComponent("current.wav")

        helper.begin(session: ObjectIdentifier(oldID), url: directory.appendingPathComponent("old.wav"))
        try helper.write(try makeBuffer(), session: ObjectIdentifier(oldID), at: 3)
        helper.begin(session: ObjectIdentifier(currentID), url: currentURL)
        try helper.write(try makeBuffer(), session: ObjectIdentifier(currentID), at: 30)

        #expect(helper.finish(session: ObjectIdentifier(oldID)).url == nil)
        try helper.write(try makeBuffer(value: 0.5), session: ObjectIdentifier(currentID), at: 31)
        let result = helper.finish(session: ObjectIdentifier(currentID))

        #expect(result.url == currentURL)
        #expect(result.startedAt == 30)
        #expect(try fileSize(currentURL) > 1024)
    }

    @Test func emptySessionReturnsNoUsableURL() throws {
        let (directory, helper) = try fixture()
        defer { try? FileManager.default.removeItem(at: directory) }
        let id = NSObject()
        let url = directory.appendingPathComponent("empty.wav")
        helper.begin(session: ObjectIdentifier(id), url: url)

        let result = helper.finish(session: ObjectIdentifier(id))

        #expect(result.url == nil)
        #expect(result.startedAt == nil)
        #expect(!FileManager.default.fileExists(atPath: url.path))
    }

    @Test func timestampResetsForEachSession() throws {
        let (directory, helper) = try fixture()
        defer { try? FileManager.default.removeItem(at: directory) }
        let firstID = NSObject()
        let secondID = NSObject()
        helper.begin(session: ObjectIdentifier(firstID), url: directory.appendingPathComponent("first.wav"))
        try helper.write(try makeBuffer(), session: ObjectIdentifier(firstID), at: 42)
        #expect(helper.finish(session: ObjectIdentifier(firstID)).startedAt == 42)

        helper.begin(session: ObjectIdentifier(secondID), url: directory.appendingPathComponent("second.wav"))
        try helper.write(try makeBuffer(), session: ObjectIdentifier(secondID), at: 99)
        #expect(helper.finish(session: ObjectIdentifier(secondID)).startedAt == 99)
    }

    private func makeBuffer(value: Float = 0.1, frames: AVAudioFrameCount = 4096) throws -> AVAudioPCMBuffer {
        let format = AVAudioFormat(standardFormatWithSampleRate: 48_000, channels: 2)!
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames)!
        buffer.frameLength = frames
        for channel in 0..<Int(format.channelCount) {
            let samples = buffer.floatChannelData![channel]
            for frame in 0..<Int(frames) { samples[frame] = value }
        }
        return buffer
    }

    private func fileSize(_ url: URL) throws -> Int {
        guard let size = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int else {
            throw CocoaError(.fileReadUnknown)
        }
        return size
    }
}
