import Foundation

/// Protocol that AppConfig.swift must conform to.
/// Implement this in MyApp/AppConfig.swift — it's the only file you need to edit.
public protocol SwiftAIAppConfig {
    static var appName: String { get }
    static var trigger: Trigger { get }
    static var actions: [Action] { get }
}

public extension SwiftAIAppConfig {
    /// Default hotkey: Cmd+Shift+V. Override in AppConfig to change.
    static var hotkeyCombo: KeyCombo {
        KeyCombo(KeyCombo.Keys.v, modifiers: [.command, .shift])
    }
}
