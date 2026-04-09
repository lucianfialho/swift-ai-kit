import Foundation
import FoundationModels

public enum LLMError: Error, LocalizedError {
    case notLoaded
    case stillLoading
    case notAvailable(String)

    public var errorDescription: String? {
        switch self {
        case .notLoaded:              return "Model not loaded. Call load() first."
        case .stillLoading:           return "Model is loading, please wait…"
        case .notAvailable(let msg):  return "Apple Intelligence unavailable: \(msg)"
        }
    }
}

@MainActor
public class LLMEngine: ObservableObject {
    @Published public var isLoading = false
    @Published public var isReady = false

    private var modelAvailable = false

    public init() {}

    /// Checks that Apple Intelligence is available on this device.
    public func load() async throws {
        guard !isLoading && !isReady else { return }
        isLoading = true
        defer { isLoading = false }

        switch SystemLanguageModel.default.availability {
        case .available:
            modelAvailable = true
            isReady = true
        case .unavailable(let reason):
            throw LLMError.notAvailable(String(describing: reason))
        }
    }

    /// Runs inference via Apple Intelligence. Each call is stateless (fresh session).
    public func run(prompt: String) async throws -> String {
        if isLoading { throw LLMError.stillLoading }
        guard modelAvailable else { throw LLMError.notLoaded }

        let session = LanguageModelSession(
            model: .default,
            tools: [],
            instructions: "You are a concise assistant. Answer directly with only what is asked. No preamble, no explanation, no markdown unless explicitly requested."
        )
        let response = try await session.respond(to: prompt)
        return response.content
    }
}
