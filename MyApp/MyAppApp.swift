import AppKit
import SwiftUI

@main
struct MyAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private let menuBar = MenuBarManager()
    private let clipboard = ClipboardMonitor()
    private let llmEngine = LLMEngine()
    private var hotkey: HotkeyManager?
    private let panel = PopupPanel()
    private var settingsWindow: NSWindow?
    private var isRunningAction = false

    @AppStorage("customActions") private var actionsData: Data = {
        (try? JSONEncoder().encode(AppConfig.actions)) ?? Data()
    }()

    private var currentActions: [Action] {
        (try? JSONDecoder().decode([Action].self, from: actionsData)) ?? AppConfig.actions
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        )

        menuBar.setup(appName: AppConfig.appName)
        menuBar.onSettingsRequested = { [weak self] in self?.openSettings() }

        switch AppConfig.trigger {
        case .clipboard:
            clipboard.onTextCopied = { [weak self] text in self?.showPicker(for: text) }
            clipboard.start()
        case .hotkey:
            let combo = AppConfig.hotkeyCombo
            hotkey = HotkeyManager(combo: combo) { [weak self] in
                if let text = NSPasteboard.general.string(forType: .string), !text.isEmpty {
                    self?.showPicker(for: text)
                }
            }
            hotkey?.start()
        case .selection:
            // Falls back to hotkey behaviour — reads whatever is already on the clipboard.
            // Reliable cross-app text selection requires Accessibility scripting beyond
            // the scope of this template.
            let combo = AppConfig.hotkeyCombo
            hotkey = HotkeyManager(combo: combo) { [weak self] in
                if let text = NSPasteboard.general.string(forType: .string), !text.isEmpty {
                    self?.showPicker(for: text)
                }
            }
            hotkey?.start()
        }

        Task {
            menuBar.setLoading(message: "Checking Apple Intelligence…")
            do {
                try await llmEngine.load()
                menuBar.setIdle()
            } catch {
                menuBar.setError(message: error.localizedDescription)
            }
        }
    }

    private func showPicker(for text: String) {
        let preview = String(text.prefix(80)) + (text.count > 80 ? "…" : "")
        let pickerView = ActionPickerView(
            actions: currentActions,
            inputPreview: preview,
            onSelect: { [weak self] action in self?.runAction(action, on: text) },
            onDismiss: { [weak self] in self?.panel.dismiss() }
        )
        panel.setContent(pickerView)
        panel.showNearCursor()
    }

    private func runAction(_ action: Action, on text: String) {
        guard !isRunningAction else { return }
        isRunningAction = true
        let prompt = action.apply(to: text)

        panel.setContent(ResultView(
            state: .loading,
            actionName: action.name,
            onCopy: { _ in },
            onBack: { [weak self] in self?.showPicker(for: text) }
        ))

        Task { @MainActor in
            defer { self.isRunningAction = false }
            do {
                let result = try await llmEngine.run(prompt: prompt)
                panel.setContent(ResultView(
                    state: .result(result),
                    actionName: action.name,
                    onCopy: { [weak self] in self?.copyToClipboard($0) },
                    onBack: { [weak self] in self?.showPicker(for: text) }
                ))
            } catch {
                panel.setContent(ResultView(
                    state: .error(error.localizedDescription),
                    actionName: action.name,
                    onCopy: { _ in },
                    onBack: { [weak self] in self?.showPicker(for: text) }
                ))
            }
        }
    }

    private func copyToClipboard(_ text: String) {
        if AppConfig.trigger == .clipboard { clipboard.stop() }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        panel.dismiss()
        if AppConfig.trigger == .clipboard {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.clipboard.start()
            }
        }
    }

    private func openSettings() {
        if let existing = settingsWindow, existing.isVisible {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let settingsView = SettingsView(initialActions: currentActions) { [weak self] updated in
            self?.actionsData = (try? JSONEncoder().encode(updated)) ?? Data()
        }
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 360),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "\(AppConfig.appName) Settings"
        window.contentView = NSHostingView(rootView: settingsView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow = window
    }
}
