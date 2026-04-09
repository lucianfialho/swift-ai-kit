import Foundation

public enum LLMModel: String, CaseIterable, Codable {
    case qwen_0_8b
    case qwen_2b
    case qwen_4b

    /// Direct download URL — avoids HuggingFace API rate limits (same approach as Ghost Pepper)
    public var downloadURL: URL {
        switch self {
        case .qwen_0_8b: return URL(string: "https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-Q4_K_M.gguf")!
        case .qwen_2b:   return URL(string: "https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/Qwen3.5-2B-Q4_K_M.gguf")!
        case .qwen_4b:   return URL(string: "https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q4_K_M.gguf")!
        }
    }

    public var fileName: String {
        switch self {
        case .qwen_0_8b: return "Qwen3.5-0.8B-Q4_K_M.gguf"
        case .qwen_2b:   return "Qwen3.5-2B-Q4_K_M.gguf"
        case .qwen_4b:   return "Qwen3.5-4B-Q4_K_M.gguf"
        }
    }

    public var displayName: String {
        switch self {
        case .qwen_0_8b: return "Qwen 0.8B (Fast, ~535 MB)"
        case .qwen_2b:   return "Qwen 2B (Balanced, ~1.3 GB)"
        case .qwen_4b:   return "Qwen 4B (Quality, ~2.8 GB)"
        }
    }

    public var approximateSize: String {
        switch self {
        case .qwen_0_8b: return "~535 MB"
        case .qwen_2b:   return "~1.3 GB"
        case .qwen_4b:   return "~2.8 GB"
        }
    }
}
