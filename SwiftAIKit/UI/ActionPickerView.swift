import SwiftUI

/// Displays the list of available actions for the user to choose from.
public struct ActionPickerView: View {
    public let actions: [Action]
    public let inputPreview: String
    public let onSelect: (Action) -> Void
    public let onDismiss: () -> Void

    public init(actions: [Action], inputPreview: String, onSelect: @escaping (Action) -> Void, onDismiss: @escaping () -> Void) {
        self.actions = actions
        self.inputPreview = inputPreview
        self.onSelect = onSelect
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "doc.on.clipboard")
                    .foregroundColor(.secondary)
                Text(inputPreview)
                    .lineLimit(2)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            ScrollView {
                VStack(spacing: 2) {
                    ForEach(actions) { action in
                        ActionRow(action: action) { onSelect(action) }
                    }
                }
                .padding(6)
            }
        }
        .frame(width: 320)
        .background(Color(NSColor.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct ActionRow: View {
    let action: Action
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: action.icon)
                    .frame(width: 20)
                    .foregroundColor(.accentColor)
                Text(action.name)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "return")
                    .foregroundColor(.secondary)
                    .opacity(isHovered ? 1 : 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(isHovered ? Color.accentColor.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
