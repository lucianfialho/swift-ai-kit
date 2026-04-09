# ane-app

A GitHub template for building **100% local** macOS menu bar apps powered by the Apple Neural Engine.

> Think of it as Next.js for macOS ANE apps — handles the boilerplate, you ship the idea.

Built on the same pattern as [Ghost Pepper](https://github.com/matthartman/ghost-pepper).

## What you get

- Menu bar app with icon + dropdown
- Local LLM inference via [LLM.swift](https://github.com/eastriverlee/LLM.swift) (Qwen models, no API key)
- Clipboard monitor, global hotkey, or text selection trigger
- Floating popup near cursor with action picker
- Result view with one-click copy
- Settings with CRUD actions + model picker
- Unsigned DMG build script

## Requirements

- macOS 14.0+ (Sonoma)
- Apple Silicon M1+
- Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Getting started

1. Click **"Use this template"** on GitHub
2. Clone your new repo
3. `brew install xcodegen && xcodegen generate`
4. Open `MyApp.xcodeproj` in Xcode
5. **Trust the LLM macro:** Xcode will prompt "Trust & Enable Macros" for `LLMMacrosImplementation` — click **Trust & Enable**. This is a one-time step.
6. Edit **`MyApp/AppConfig.swift`** — the only file you need to touch
7. Press `Cmd+R` to run

## AppConfig.swift

```swift
struct AppConfig: ANEAppConfig {
    static let appName      = "My App"
    static let bundleID     = "com.yourname.myapp"
    static let trigger      = Trigger.clipboard   // .clipboard | .hotkey | .selection
    static let defaultModel = LLMModel.qwen_0_8b
    static let actions: [Action] = [
        Action("Format JSON", prompt: "Format as JSON: {input}", icon: "curlybraces"),
        Action("Translate",   prompt: "Translate to PT: {input}", icon: "globe"),
    ]
}
```

`{input}` is replaced with the captured text at runtime.

## Triggers

| Trigger | Behavior |
|---|---|
| `.clipboard` | Monitors clipboard — popup appears when you copy text |
| `.hotkey` | Press `Cmd+Shift+V` to trigger with current clipboard |
| `.selection` | Press `Cmd+Shift+V` to trigger with selected text |

## Models

Downloaded automatically from Hugging Face on first use, cached in `~/Library/Caches`.

| Model | Size | Speed |
|---|---|---|
| Qwen 0.8B (default) | ~535 MB | ~1-2s |
| Qwen 2B | ~1.3 GB | ~4-5s |
| Qwen 4B | ~2.8 GB | ~5-7s |

## Distribute

```bash
chmod +x scripts/build-dmg.sh
./scripts/build-dmg.sh
```

Produces an **unsigned DMG**. Users on macOS Sequoia+ will see a Gatekeeper warning:

> **System Settings → Privacy & Security → Open Anyway** (one-time step)

## Project structure

```
ane-app/
  ANEKit/              framework (don't edit)
    Core/              MenuBarManager, LLMEngine, ClipboardMonitor, HotkeyManager
    UI/                PopupPanel, ActionPickerView, ResultView, SettingsView
    Models/            Action, Trigger, LLMModel, ANEAppConfig
  MyApp/               your app (edit here)
    AppConfig.swift    the only file you need to edit
    MyAppApp.swift     @main entry point
  ANEKitTests/         unit tests
  scripts/             build-dmg.sh
```

## License

MIT
