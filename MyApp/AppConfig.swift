import Foundation

// ============================================================
//  AppConfig.swift — THE ONLY FILE YOU NEED TO EDIT
//  Rename MyApp → your app name everywhere, then configure below.
// ============================================================

struct AppConfig: ANEAppConfig {
    static let appName = "My ANE App"
    static let trigger = Trigger.hotkey   // popup abre com Cmd+Shift+V

    static let actions: [Action] = [
        Action("Format JSON",     prompt: "Format the following as pretty-printed JSON. Return only the JSON, no explanation:\n\n{input}",    icon: "curlybraces"),
        Action("Translate EN→PT", prompt: "Translate the following text to Brazilian Portuguese. Return only the translation:\n\n{input}",    icon: "globe"),
        Action("Summarize",       prompt: "Summarize the following in 2 concise bullet points:\n\n{input}",                                  icon: "text.quote"),
        Action("Fix Grammar",     prompt: "Fix grammar and spelling in the following text. Return only the corrected text:\n\n{input}",       icon: "checkmark.seal"),
    ]
}
