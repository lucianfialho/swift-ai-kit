import SwiftUI

/// Settings window: manage custom actions (CRUD).
public struct SettingsView: View {
    @State private var actions: [Action]
    @State private var editingAction: Action?
    @State private var showingAddSheet = false

    private let onActionsChanged: ([Action]) -> Void

    public init(initialActions: [Action], onActionsChanged: @escaping ([Action]) -> Void) {
        _actions = State(initialValue: initialActions)
        self.onActionsChanged = onActionsChanged
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actions")
                .font(.headline)

            List {
                ForEach(actions) { action in
                    HStack {
                        Image(systemName: action.icon)
                            .frame(width: 24)
                        VStack(alignment: .leading) {
                            Text(action.name).fontWeight(.medium)
                            Text(action.prompt)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Button("Edit") { editingAction = action }
                            .buttonStyle(.plain)
                            .foregroundColor(.accentColor)
                    }
                }
                .onDelete(perform: deleteActions)
                .onMove(perform: moveActions)
            }
            .listStyle(.bordered)

            HStack {
                Label("Powered by Apple Intelligence", systemImage: "sparkles")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Add Action") { showingAddSheet = true }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 480, height: 360)
        .sheet(isPresented: $showingAddSheet) {
            ActionEditSheet(action: nil) { newAction in
                actions.append(newAction)
                onActionsChanged(actions)
            }
        }
        .sheet(item: $editingAction) { action in
            ActionEditSheet(action: action) { updated in
                if let index = actions.firstIndex(where: { $0.id == updated.id }) {
                    actions[index] = updated
                    onActionsChanged(actions)
                }
            }
        }
    }

    private func deleteActions(at offsets: IndexSet) {
        actions.remove(atOffsets: offsets)
        onActionsChanged(actions)
    }

    private func moveActions(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
        onActionsChanged(actions)
    }
}

private struct ActionEditSheet: View {
    let existing: Action?
    let onSave: (Action) -> Void

    @State private var name: String
    @State private var prompt: String
    @State private var icon: String
    @Environment(\.dismiss) private var dismiss

    init(action: Action?, onSave: @escaping (Action) -> Void) {
        self.existing = action
        self.onSave = onSave
        _name = State(initialValue: action?.name ?? "")
        _prompt = State(initialValue: action?.prompt ?? "")
        _icon = State(initialValue: action?.icon ?? "wand.and.stars")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(existing == nil ? "New Action" : "Edit Action")
                .font(.headline)

            LabeledContent("Name") {
                TextField("e.g. Format JSON", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Icon") {
                TextField("SF Symbol name", text: $icon)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Prompt")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextEditor(text: $prompt)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 80)
                    .border(Color(NSColor.separatorColor))
                Text("Use {input} where the selected text should be inserted.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let saved = Action(name, prompt: prompt, icon: icon, id: existing?.id ?? UUID())
                    onSave(saved)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || prompt.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
    }
}
