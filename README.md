# ANEKit

A Swift framework and Xcode template for building macOS apps powered by **Apple Intelligence** — no API key, no model download, runs entirely on-device via the Apple Neural Engine.

> Define your actions in one file. ANEKit handles everything else.

---

## How it works

[`FoundationModels`](https://developer.apple.com/documentation/foundationmodels) is Apple's official framework (WWDC 2025) for on-device LLM inference — no download, no API key, runs on the ANE automatically. ANEKit wraps it so you only define **Actions** (name, prompt, SF Symbol icon); the framework handles capture, inference, and result presentation.


## What the reference implementation includes

The included `MyApp` target is a menu bar app — but that's just one way to use ANEKit. The framework itself is UI-agnostic.

- Menu bar icon with status states
- Global hotkey (`Cmd+Shift+V`) or clipboard trigger
- Floating popup near cursor with action picker
- Result view with one-click copy to clipboard
- Settings window with full action CRUD

## Requirements

- **macOS 26** (Tahoe) or later
- **Apple Silicon** with Apple Intelligence enabled
- Xcode 26+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Getting started

```bash
# 1. Use this template on GitHub, then clone your repo
git clone https://github.com/your-username/your-app-name
cd your-app-name

# 2. Generate the Xcode project
xcodegen generate

# 3. Open in Xcode
open MyApp.xcodeproj
```

4. Set your **Team** in Xcode → Signing & Capabilities (or set `DEVELOPMENT_TEAM` in `project.yml`)
5. Edit **`MyApp/AppConfig.swift`** — the only file you need to touch
6. `Cmd+R` to run

## AppConfig.swift

```swift
struct AppConfig: ANEAppConfig {
    static let appName = "My App"
    static let trigger = Trigger.hotkey  // .clipboard | .hotkey

    static let actions: [Action] = [
        Action("Format JSON",     prompt: "Format as pretty JSON. Return only the JSON:\n\n{input}",              icon: "curlybraces"),
        Action("Translate EN→PT", prompt: "Translate to Brazilian Portuguese. Return only the translation:\n\n{input}", icon: "globe"),
        Action("Summarize",       prompt: "Summarize in 2 bullet points:\n\n{input}",                             icon: "text.quote"),
        Action("Fix Grammar",     prompt: "Fix grammar and spelling. Return only the corrected text:\n\n{input}", icon: "checkmark.seal"),
    ]
}
```

`{input}` is replaced with the captured text at runtime.

## Triggers

| Trigger | Behavior |
|---|---|
| `.hotkey` | Press `Cmd+Shift+V` — uses current clipboard content |
| `.clipboard` | Popup appears automatically whenever you copy text |

## Project structure

```
ane-kit/
  ANEKit/                     framework — don't edit
    Core/
      LLMEngine.swift         FoundationModels session management
      MenuBarManager.swift    status bar icon and menu
      HotkeyManager.swift     global hotkey listener
      ClipboardMonitor.swift  clipboard polling
    UI/
      PopupPanel.swift        floating NSPanel near cursor
      ActionPickerView.swift  action list
      ResultView.swift        result + copy button
      SettingsView.swift      action CRUD
    Models/
      Action.swift            Action model + {input} substitution
      Trigger.swift           trigger enum
      ANEAppConfig.swift      protocol your AppConfig must conform to
  MyApp/                      reference implementation — edit here
    AppConfig.swift           ← the only file you need to touch
    MyAppApp.swift            @main entry point + AppDelegate
  ANEKitTests/                unit tests
```

## License

MIT
