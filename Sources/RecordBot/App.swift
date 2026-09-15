import AppKit
import AVFoundation
import Carbon.HIToolbox
import Foundation

/// One in-flight or failed transcription, read off the Status/ marker files.
struct JobStatus {
    let name: String
    let stage: String        // queued, converting, transcribing, writing, or a failure reason
    let startedAt: Date?
    let pid: pid_t?
    let audioPath: String?
    let failed: Bool

    var elapsed: String {
        guard let startedAt else { return "" }
        let seconds = Int(Date().timeIntervalSince(startedAt))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    private let recorder = AudioRecorder()
    private var statusItem: NSStatusItem!
    private let menu = NSMenu()
    private var hotKey: HotKey?
    private var startedAt: Date?
    private var tickTimer: Timer?

    /// Root of the Record-Bot folder. The .app lives inside it; override with RECORDBOT_HOME.
    private lazy var home: URL = {
        if let override = ProcessInfo.processInfo.environment["RECORDBOT_HOME"] {
            return URL(fileURLWithPath: override)
        }
        return Bundle.main.bundleURL.deletingLastPathComponent()
    }()

    private var recordingsDir: URL { home.appendingPathComponent("Recordings") }
    private var transcriptsDir: URL { home.appendingPathComponent("Transcripts") }
    private var statusDir: URL { home.appendingPathComponent("Status") }
    private var actionItemsFile: URL { home.appendingPathComponent("ACTION-ITEMS.md") }
    private var transcribeScript: URL { home.appendingPathComponent("scripts/transcribe.sh") }
    private var logFile: URL { home.appendingPathComponent("recordbot.log") }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        menu.delegate = self
        statusItem.menu = menu
        refreshTitle()

        // Control + Option + R
        hotKey = HotKey(
            keyCode: UInt32(kVK_ANSI_R),
            modifiers: UInt32(controlKey | optionKey)
        ) { [weak self] in
            self?.toggle()
        }

        if hotKey == nil {
            report(title: "Hotkey unavailable", body: "Control-Option-R is taken. Use the menu instead.")
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(streamDied),
            name: AudioRecorder.streamDied,
            object: nil
        )

        for dir in [recordingsDir, transcriptsDir, statusDir] {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        // Asked once, up front, so the first recording is not the thing that
        // triggers a permission dialog mid-meeting. Denial is survivable: the
        // call still gets recorded, just without your own clean track.
        // Only inside a real bundle: TCC kills any process that asks for the mic
        // without NSMicrophoneUsageDescription, and a bare SwiftPM binary has no
        // Info.plist. Inside the bundle AVAudioEngine would prompt anyway.
        if Bundle.main.bundleIdentifier != nil,
           AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if !granted {
                    NSLog("RecordBot: microphone access denied, own-voice track disabled")
                }
            }
        }

        // Keeps the menu bar title honest about recording time and background jobs.
        tickTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            Task { @MainActor [weak self] in self?.refreshTitle() }
        }
    }

    // MARK: - Reading job status off disk

    private func jobs() -> [JobStatus] {
        let files = (try? FileManager.default.contentsOfDirectory(at: statusDir, includingPropertiesForKeys: nil)) ?? []
        var result: [JobStatus] = []

        for url in files.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
            let name = url.deletingPathExtension().lastPathComponent
            let body = (try? String(contentsOf: url, encoding: .utf8))?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            switch url.pathExtension {
            case "status":
                // format: "<stage> <epoch> <pid> <audio path>" or legacy "<stage> <epoch> <audio path>"
                let parts = body.split(separator: " ").map(String.init)
                let stage = parts.first ?? "working"
                let started = parts.count > 1 ? Double(parts[1]).map { Date(timeIntervalSince1970: $0) } : nil
                var pid: pid_t? = nil
                var audioPath: String? = nil
                if parts.count >= 4 {
                    pid = pid_t(parts[2])
                    audioPath = parts.dropFirst(3).joined(separator: " ")
                } else if parts.count == 3 {
                    if let p = pid_t(parts[2]) {
                        pid = p
                    } else {
                        audioPath = parts[2]
                    }
                }

                // If process is dead, auto-fail stale marker rather than showing forever
                if let p = pid, p > 0, kill(p, 0) != 0, errno == ESRCH {
                    let failedURL = statusDir.appendingPathComponent("\(name).failed")
                    try? "process exited unexpectedly (PID \(p) died)".write(to: failedURL, atomically: true, encoding: .utf8)
                    try? FileManager.default.removeItem(at: url)
                    result.append(JobStatus(name: name, stage: "process died", startedAt: nil, pid: nil, audioPath: audioPath, failed: true))
                    continue
                }

                result.append(JobStatus(name: name, stage: stage, startedAt: started,
                                        pid: pid, audioPath: audioPath, failed: false))
            case "failed":
                result.append(JobStatus(name: name, stage: body.isEmpty ? "failed" : body,
                                        startedAt: nil, pid: nil, audioPath: nil, failed: true))
            default:
                break
            }
        }
        return result
    }

    private func awaitingSummaryCount() -> Int {
        let files = (try? FileManager.default.contentsOfDirectory(at: transcriptsDir, includingPropertiesForKeys: nil)) ?? []
        return files.filter { $0.pathExtension == "md" }.filter { url in
            guard let head = try? String(contentsOf: url, encoding: .utf8).prefix(400) else { return false }
            return head.contains("status: awaiting-summary")
        }.count
    }

    // MARK: - Menu bar title

    private func refreshTitle() {
        var pieces: [String] = []

        if recorder.isRecording, let startedAt {
            let seconds = Int(Date().timeIntervalSince(startedAt))
            pieces.append(String(format: "● %d:%02d", seconds / 60, seconds % 60))
        } else {
            pieces.append("◉")
        }

        let active = jobs()
        let running = active.filter { !$0.failed }.count
        let broken = active.filter(\.failed).count
        if running > 0 { pieces.append(running == 1 ? "⋯" : "⋯\(running)") }
        if broken > 0 { pieces.append("⚠") }

        statusItem.button?.title = pieces.joined(separator: " ")
    }

    // MARK: - Menu

    /// Rebuilt every time the menu opens, so what you see is current.
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        menu.autoenablesItems = false

        let isRecording = recorder.isRecording

        let toggleItem = NSMenuItem(
            title: isRecording ? "Stop Recording" : "Start Recording",
            action: #selector(toggleFromMenu),
            keyEquivalent: ""
        )
        toggleItem.target = self
        menu.addItem(toggleItem)

        if isRecording, let startedAt {
            let seconds = Int(Date().timeIntervalSince(startedAt))
            menu.addItem(disabled(String(format: "Recording  %d:%02d", seconds / 60, seconds % 60)))
        }

        menu.addItem(disabled("Hotkey: ⌃⌥R"))

        // Transcription
        let active = jobs()
        let running = active.filter { !$0.failed }
        let broken = active.filter(\.failed)

        menu.addItem(.separator())
        menu.addItem(header("Transcription"))

        if running.isEmpty && broken.isEmpty {
            menu.addItem(disabled("  Idle"))
        }
        for job in running {
            let pidStr = job.pid != nil ? " (PID \(job.pid!))" : ""
            let item = NSMenuItem(title: "  \(prettyName(job.name)) — \(job.stage) \(job.elapsed)\(pidStr)  [Cancel]", action: #selector(cancelRunningJob(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = job.pid.map { Int($0) }
            item.toolTip = "Click to cancel this transcription"
            menu.addItem(item)
        }
        for job in broken {
            let item = NSMenuItem(title: "  \(prettyName(job.name)) — failed", action: #selector(openLog), keyEquivalent: "")
            item.target = self
            item.toolTip = job.stage
            menu.addItem(item)
        }
        if !broken.isEmpty {
            let retry = NSMenuItem(title: "  Retry failed (\(broken.count))", action: #selector(retryFailed), keyEquivalent: "")
            retry.target = self
            menu.addItem(retry)
        }

        // Summaries
        let waiting = awaitingSummaryCount()
        menu.addItem(.separator())
        menu.addItem(header("Summaries"))
        menu.addItem(disabled(waiting == 0
            ? "  All caught up"
            : "  \(waiting) transcript\(waiting == 1 ? "" : "s") awaiting Claude"))

        menu.addItem(.separator())

        for (title, selector) in [
            ("Pause Transcription/Summarisation", #selector(pauseProcessing)),
            ("Resume Transcription/Summarisation", #selector(resumeProcessing)),
            ("Open Transcripts Folder", #selector(openTranscripts)),
            ("Open Action Items", #selector(openActionItems)),
            ("Open Log", #selector(openLog))
        ] {
            let item = NSMenuItem(title: title, action: selector, keyEquivalent: "")
            item.target = self
            menu.addItem(item)
        }

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit RecordBot", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
    }

    private func disabled(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }

    private func header(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false
        item.attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize, weight: .semibold),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
        )
        return item
    }

    /// 2026-08-25_14-30-00 reads better as Aug 25, 14:30
    private func prettyName(_ base: String) -> String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        guard let date = parser.date(from: base) else { return base }
        let out = DateFormatter()
        out.dateFormat = "MMM d, HH:mm"
        return out.string(from: date)
    }

    // MARK: - Actions

    @objc private func toggleFromMenu() { toggle() }

    @objc private func openTranscripts() {
        NSWorkspace.shared.open(transcriptsDir)
    }

    @objc private func openActionItems() {
        if !FileManager.default.fileExists(atPath: actionItemsFile.path) {
            try? "# Action Items\n\nNothing yet.\n".write(to: actionItemsFile, atomically: true, encoding: .utf8)
        }
        NSWorkspace.shared.open(actionItemsFile)
    }

    @objc private func openLog() {
        if !FileManager.default.fileExists(atPath: logFile.path) {
            try? "".write(to: logFile, atomically: true, encoding: .utf8)
        }
        NSWorkspace.shared.open(logFile)
    }

    /// Failed jobs keep their WAV, so a retry is just running the script again.
    @objc private func retryFailed() {
        let failures = jobs().filter(\.failed)
        var retried = 0

        for job in failures {
            let wav = recordingsDir.appendingPathComponent("\(job.name).wav")
            guard FileManager.default.fileExists(atPath: wav.path) else { continue }
            try? FileManager.default.removeItem(at: statusDir.appendingPathComponent("\(job.name).failed"))
            launchTranscription(for: wav)
            retried += 1
        }

        report(
            title: retried > 0 ? "Retrying \(retried)" : "Nothing to retry",
            body: retried > 0 ? "Transcription restarted." : "The audio for those jobs is gone."
        )
        refreshTitle()
    }

    @objc private func cancelRunningJob(_ sender: NSMenuItem) {
        if let pidNum = sender.representedObject as? Int, pidNum > 0 {
            kill(pid_t(pidNum), SIGTERM)
            report(title: "Job cancelled", body: "Terminated transcription process (PID \(pidNum)).")
            refreshTitle()
        }
    }

    @objc private func pauseProcessing() {
        Task {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            // Send SIGSTOP (like Ctrl+Z) to freeze the processes in place
            process.arguments = ["-c", "pkill -STOP -f transcribe.sh; pkill -STOP -f whisper-cli; pkill -STOP -f summarize.py; curl -s -X POST http://localhost:11434/api/generate -d '{\"model\": \"qwen2.5:14b\", \"keep_alive\": 0}' > /dev/null &"]
            try? process.run()
            
            Task { @MainActor in
                report(title: "Processing Paused", body: "Tasks suspended (Ctrl+Z). Memory will swap to disk.")
                refreshTitle()
            }
        }
    }

    @objc private func resumeProcessing() {
        Task {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            // Send SIGCONT to resume the processes
            process.arguments = ["-c", "pkill -CONT -f transcribe.sh; pkill -CONT -f whisper-cli; pkill -CONT -f summarize.py"]
            try? process.run()
            
            Task { @MainActor in
                report(title: "Processing Resumed", body: "Suspended tasks have been resumed.")
                refreshTitle()
            }
        }
    }

    @objc private func quit() {
        Task { @MainActor in
            if recorder.isRecording { _ = await recorder.stop() }
            NSApp.terminate(nil)
        }
    }

    /// The capture stream fell over without being asked to stop.
    @objc private func streamDied() {
        resetIdleState()
        report(title: "Recording interrupted", body: "The audio stream stopped. See the log.")
    }

    // MARK: - Recording

    private func toggle() {
        Task { @MainActor in
            if recorder.isRecording {
                let url = await recorder.stop()
                resetIdleState()

                if let url {
                    let shouldProceed = askForContext(about: url)
                    if shouldProceed {
                        report(title: "Recording saved", body: "Transcribing in the background.")
                        launchTranscription(for: url)
                    } else {
                        report(title: "Recording discarded", body: "Audio was removed.")
                    }
                } else {
                    report(title: "Nothing captured", body: "No audio was playing, so no file was kept.")
                }
            } else {
                do {
                    _ = try await recorder.start(in: recordingsDir)
                    startedAt = Date()
                    refreshTitle()
                    report(title: "Recording started", body: "Capturing system audio.")
                } catch {
                    resetIdleState()
                    report(title: "Could not start", body: error.localizedDescription)
                }
            }
        }
    }

    private func resetIdleState() {
        startedAt = nil
        refreshTitle()
    }

    /// Asks what the meeting was, right after stopping, while it's still fresh.
    /// The answers go in a sidecar .meta file that the transcript inherits, so Claude
    /// summarizes with some idea of who was talking and why.
    /// Returns true if transcription should proceed, or false if discarded.
    private func askForContext(about wav: URL) -> Bool {
        let alert = NSAlert()
        alert.messageText = "What was this meeting?"
        alert.informativeText = "All of this is optional. Anything you fill in gets handed "
            + "to Claude along with the transcript."
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Skip")
        alert.addButton(withTitle: "Discard")
        alert.window.level = .floating

        let width: CGFloat = 420
        let container = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 300))

        func label(_ text: String, y: CGFloat) -> NSTextField {
            let field = NSTextField(labelWithString: text)
            field.frame = NSRect(x: 0, y: y, width: width, height: 15)
            field.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize, weight: .semibold)
            field.textColor = .secondaryLabelColor
            return field
        }

        let titleField = NSTextField(frame: NSRect(x: 0, y: 256, width: width, height: 24))
        titleField.placeholderString = "Acme pricing review"

        let contextField = NSTextField(frame: NSRect(x: 0, y: 202, width: width, height: 24))
        contextField.placeholderString = "Me, Priya, two people from their finance team"

        let watchField = NSTextField(frame: NSRect(x: 0, y: 148, width: width, height: 24))
        watchField.placeholderString = "Did they commit to a date for the migration?"

        // Notes get a real text view: pasted bullets and line breaks survive.
        let notesView = NSTextView(frame: NSRect(x: 0, y: 0, width: width, height: 120))
        notesView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        notesView.isRichText = false
        notesView.isAutomaticQuoteSubstitutionEnabled = false
        notesView.textContainerInset = NSSize(width: 4, height: 4)

        let notesScroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: width, height: 120))
        notesScroll.documentView = notesView
        notesScroll.hasVerticalScroller = true
        notesScroll.borderType = .bezelBorder

        container.addSubview(label("Title", y: 281))
        container.addSubview(titleField)
        container.addSubview(label("Who was there, what it was for", y: 227))
        container.addSubview(contextField)
        container.addSubview(label("A question for the summarizer to answer", y: 173))
        container.addSubview(watchField)
        container.addSubview(label("Your own notes from the meeting", y: 125))
        container.addSubview(notesScroll)

        alert.accessoryView = container

        NSApp.activate(ignoringOtherApps: true)
        alert.window.initialFirstResponder = titleField
        let modalResponse = alert.runModal()
        let base = wav.deletingPathExtension()

        if modalResponse == .alertThirdButtonReturn {
            // Discard clicked: remove audio and sidecars
            try? FileManager.default.removeItem(at: wav)
            try? FileManager.default.removeItem(at: base.appendingPathExtension("mic.wav"))
            try? FileManager.default.removeItem(at: base.appendingPathExtension("sync"))
            return false
        }

        let clickedSave = modalResponse == .alertFirstButtonReturn
        guard clickedSave else { return true }

        func clean(_ field: NSTextField) -> String {
            field.stringValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\n", with: " ")
        }

        // Header fields are one line each, so the transcript header stays parseable.
        var lines: [String] = []
        let title = clean(titleField)
        let context = clean(contextField)
        let watch = clean(watchField)
        if !title.isEmpty { lines.append("title: \(title)") }
        if !context.isEmpty { lines.append("context: \(context)") }
        if !watch.isEmpty { lines.append("watch_for: \(watch)") }
        if !lines.isEmpty {
            try? (lines.joined(separator: "\n") + "\n")
                .write(to: base.appendingPathExtension("meta"), atomically: true, encoding: .utf8)
        }

        // Notes are free-form and multi-line, so they travel in their own file
        // and land in the transcript as a section rather than a header field.
        let notes = notesView.string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !notes.isEmpty {
            try? (notes + "\n")
                .write(to: base.appendingPathExtension("notes"), atomically: true, encoding: .utf8)
        }

        return true
    }

    /// Fires the transcription script and forgets about it. The script publishes its own
    /// progress into Status/ and recordbot.log.
    private func launchTranscription(for wav: URL) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [transcribeScript.path, wav.path]
        process.currentDirectoryURL = home
        process.environment = ProcessInfo.processInfo.environment.merging(
            ["RECORDBOT_HOME": home.path]
        ) { _, new in new }

        do {
            try process.run()
        } catch {
            report(title: "Transcription failed to start", body: error.localizedDescription)
        }
    }

    /// UNUserNotificationCenter needs a notarized bundle with entitlements, so status
    /// updates go to the tooltip and the log instead of Notification Center.
    private func report(title: String, body: String) {
        NSLog("RecordBot: \(title) — \(body)")
        statusItem?.button?.toolTip = "\(title): \(body)"
    }
}

/// An explicit entry point rather than top-level code: newer toolchains treat the
/// body of main.swift as nonisolated, which cannot touch a @MainActor class.
@main
@MainActor
struct RecordBotMain {
    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        app.delegate = delegate
        app.run()
    }
}
