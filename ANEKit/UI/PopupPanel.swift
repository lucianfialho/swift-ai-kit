import AppKit
import SwiftUI

/// A floating NSPanel that appears near the cursor position.
public class PopupPanel: NSPanel {
    public init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 240),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        isFloatingPanel = true
        level = .floating
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        isMovableByWindowBackground = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isOpaque = false
        backgroundColor = NSColor.windowBackgroundColor
    }

    public func setContent<V: View>(_ view: V) {
        contentView = NSHostingView(rootView: view)
    }

    /// Shows panel positioned near cursor, clamped to screen bounds.
    public func showNearCursor() {
        let cursor = NSEvent.mouseLocation
        let screen = NSScreen.screens.first(where: { $0.frame.contains(cursor) }) ?? NSScreen.main
        guard let screen else { return }
        let screenFrame = screen.visibleFrame
        var origin = NSPoint(
            x: cursor.x + 8,
            y: cursor.y - frame.height - 8
        )
        origin.x = min(origin.x, screenFrame.maxX - frame.width - 8)
        origin.y = max(origin.y, screenFrame.minY + 8)
        setFrameOrigin(origin)
        makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    public func dismiss() {
        orderOut(nil)
    }

    public override var canBecomeKey: Bool { true }
}
