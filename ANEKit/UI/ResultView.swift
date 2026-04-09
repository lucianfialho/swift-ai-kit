import SwiftUI

/// Shows the LLM result text with a Copy button and loading/error states.
public struct ResultView: View {
    public enum ResultViewState {
        case loading
        case result(String)
        case error(String)
    }

    public let state: ResultViewState
    public let actionName: String
    public let onCopy: (String) -> Void
    public let onBack: () -> Void

    public init(state: ResultViewState, actionName: String, onCopy: @escaping (String) -> Void, onBack: @escaping () -> Void) {
        self.state = state
        self.actionName = actionName
        self.onCopy = onCopy
        self.onBack = onBack
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                Text(actionName)
                    .font(.headline)
                    .padding(.leading, 4)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            Group {
                switch state {
                case .loading:
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Processing...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(24)

                case .result(let text):
                    VStack(alignment: .leading, spacing: 12) {
                        ScrollView {
                            Text(text)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                        }
                        .frame(maxHeight: 160)

                        HStack {
                            Spacer()
                            Button("Copy") {
                                onCopy(text)
                            }
                            .keyboardShortcut(.return, modifiers: [])
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)
                    }

                case .error(let message):
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                }
            }
        }
        .frame(width: 320)
        .background(Color(NSColor.windowBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
