import AppKit
import SwiftUI

public class MenuBarManager: NSObject {
    private var statusItem: NSStatusItem?
    private var appName: String = ""
    private var iconSymbol: String = "sparkles"
    public var onSettingsRequested: (() -> Void)?

    public override init() {
        super.init()
    }

    /// Call once at app launch. Installs the menu bar icon and dropdown menu.
    public func setup(appName: String, iconSymbol: String = "sparkles") {
        self.appName = appName
        self.iconSymbol = iconSymbol
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        setIdle()

        let menu = NSMenu()
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem?.menu = menu
    }

    /// Show loading spinner text
    public func setLoading(message: String = "Loading…") {
        guard let button = statusItem?.button else { return }
        button.image = nil
        button.title = "⏳"
        button.toolTip = message
    }

    /// Show ready state — back to icon only
    public func setIdle() {
        guard let button = statusItem?.button else { return }
        button.title = ""
        button.image = NSImage(systemSymbolName: iconSymbol, accessibilityDescription: appName)
        button.toolTip = appName
    }

    /// Show error state
    public func setError(message: String) {
        guard let button = statusItem?.button else { return }
        button.image = nil
        button.title = "⚠️"
        button.toolTip = message
    }

    @objc private func openSettings() {
        onSettingsRequested?()
    }
}
