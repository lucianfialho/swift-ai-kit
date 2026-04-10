# README Redesign — Design Doc

**Date:** 2026-04-09  
**Project:** SwiftAIKit  

---

## Context

The current README covers the basics but lacks a strong pitch, visual appeal, and clear onboarding flow. Goal: make developers understand and start using the framework as fast as possible, while also attracting contributors.

## Goals (prioritized)

1. **Quick onboarding** — a dev should understand what it is and have it running in < 5 minutes
2. **Attract developers/contributors** — compelling enough to earn stars and pull requests
3. **Look professional** — credible as an open source Swift framework

## Target audience

- **Primary:** Swift developer starting a new macOS app and wants to add Apple Intelligence
- **Secondary:** Swift developer with an existing macOS app who wants to integrate the framework

## Tone

Dev-friendly/indie — direct, with personality. Inspired by Ice, popular Swift open source projects. Not cold or corporate.

## Approach

**A + B hybrid:** Code-first hero (approach A) with a punchy problem/solution opening (approach B).  
The simplicity of `AppConfig.swift` IS the pitch — show it immediately, but frame it with 1-2 sentences of context first.

---

## Structure

### 1. Header

```markdown
# SwiftAIKit

> Apple Intelligence in your macOS app. No API key. No model download. Just actions.
```

- Tagline uses 3 "no"s in sequence for rhythm
- Immediately communicates the key differentiators

### 2. Opening pitch + code hero

- 1 sentence naming the pain (API keys, model downloads, network errors, privacy)
- Immediately followed by the minimal `AppConfig.swift` example
- Closes with "That's it. SwiftAIKit handles capture, inference, and result presentation."

### 3. Requirements

Unchanged from current. Lists:
- macOS 26 (Tahoe)+
- Apple Silicon with Apple Intelligence enabled
- Xcode 26+
- XcodeGen

### 4. Getting Started

Streamlined: `xcodegen generate && open MyApp.xcodeproj` as a single command.  
5 numbered steps total — same content, less friction.

### 5. Features (NEW)

Bullet list with bold labels. Key additions vs. current README:
- **Zero configuration** — one file
- **Fully on-device** — no internet
- **Privacy first** — text never leaves device (underemphasized in current README)
- **Two trigger modes**
- **Full action CRUD**
- **UI-agnostic framework** — clarifies MyApp is just an example

### 6. AppConfig.swift

Same code block. Added subtitle: "The only file you edit."

### 7. Triggers

Same table. Unchanged.

### 8. Project structure

Same tree. Minor formatting cleanup (removed extra indent level).

### 9. Using SwiftAIKit in an existing app (NEW)

Covers the secondary use case. The actual integration requires:
1. Add `SwiftAIKit` as a Swift package dependency
2. Create `AppConfig.swift` conforming to `SwiftAIAppConfig`
3. Copy `AppDelegate` from the template and wire it to your app's entry point

**Note:** There is no single-call API (e.g. `SwiftAIKit.start(config:)`). The README copy for this section should reflect the real steps above, not a simplified fake API. Owner to write final copy.

### 10. License

MIT. Unchanged.

---

## What was intentionally excluded

- **Screenshots/GIFs:** Not available yet. Can be added as a Gallery section later.
- **Badges:** Low priority given onboarding focus. Can be added (platform, license, swift version) in a follow-up.
- **Contributing guide:** Out of scope for this iteration.
- **Roadmap/checklist:** Out of scope. Project is early stage.

---

## Success criteria

- A Swift dev with no prior knowledge of the project can understand what it does and have it running in under 5 minutes
- The opening section communicates the key differentiator (on-device, no API key, privacy) without scrolling
- The code example appears above the fold on most screens
