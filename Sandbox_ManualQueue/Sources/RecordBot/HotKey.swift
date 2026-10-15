import Carbon.HIToolbox
import Foundation

/// A single system-wide hotkey registered through Carbon.
/// Carbon is ancient but it is the only way to grab a global key without
/// asking the user for Accessibility permission.
final class HotKey {

    private static let lock = NSLock()
    private static var handlers: [UInt32: () -> Void] = [:]
    private static var nextID: UInt32 = 1
    private static var eventHandler: EventHandlerRef?

    private var ref: EventHotKeyRef?
    private let id: UInt32

    /// - Parameters:
    ///   - keyCode: virtual key code, e.g. `kVK_ANSI_R`
    ///   - modifiers: Carbon modifier mask, e.g. `UInt32(controlKey | optionKey)`
    init?(keyCode: UInt32, modifiers: UInt32, handler: @escaping () -> Void) {
        Self.installHandlerIfNeeded()

        Self.lock.lock()
        id = Self.nextID
        Self.nextID += 1
        Self.handlers[id] = handler
        Self.lock.unlock()

        let hotKeyID = EventHotKeyID(signature: OSType(0x52424F54), id: id) // 'RBOT'
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &ref
        )
        if status != noErr {
            Self.lock.lock()
            Self.handlers[id] = nil
            Self.lock.unlock()
            return nil
        }
    }

    deinit {
        if let ref { UnregisterEventHotKey(ref) }
        Self.lock.lock()
        Self.handlers[id] = nil
        Self.lock.unlock()
    }

    fileprivate static func handler(for id: UInt32) -> (() -> Void)? {
        lock.lock(); defer { lock.unlock() }
        return handlers[id]
    }

    private static func installHandlerIfNeeded() {
        lock.lock()
        let alreadyInstalled = eventHandler != nil
        lock.unlock()
        guard !alreadyInstalled else { return }

        var spec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        var installed: EventHandlerRef?

        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, _ -> OSStatus in
                var hotKeyID = EventHotKeyID()
                let err = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                guard err == noErr else { return err }
                if let handler = HotKey.handler(for: hotKeyID.id) {
                    DispatchQueue.main.async(execute: handler)
                }
                return noErr
            },
            1,
            &spec,
            nil,
            &installed
        )

        lock.lock()
        eventHandler = installed
        lock.unlock()
    }
}
