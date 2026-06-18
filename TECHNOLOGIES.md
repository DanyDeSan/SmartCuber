# SmartCuber — Technologies

This document lists all languages, frameworks, and development tools used in the project.
Any time a new technology is adopted, it must be added here.

---

## Languages

| Language | Version | Purpose |
|---|---|---|
| Swift | 5.x | Primary language for all app and test code |

## Frameworks

| Framework | Purpose |
|---|---|
| SwiftUI | Declarative UI layer for all views |
| Liquid Glass | iOS 26 design system — native `TabView`/`Menu`s adopt it automatically; custom card surfaces use `.glassEffect()` |
| SwiftData | Persistence — model definition, storage, and reactive queries |
| Swift Observation | Reactive state via `@Observable` (view models, coordinator, settings) — **Combine is not used** |
| Swift Concurrency | Async work via `async`/`await` and `Task`; the timer clock + arm countdown use `Task.sleep` — **Combine is not used** |
| UIKit | Haptic feedback (`UIFeedbackGenerator`), the scramble clipboard, and the `TwoFingerTouchSurface` multitouch bridge |
| Swift Testing | Unit testing (`@Test`, `#expect`, `#require`) |

> Minimum deployment target is **iOS 26.0** — required for Liquid Glass.

## Tools

| Tool | Purpose |
|---|---|
| Xcode 26+ | IDE and build system (Liquid Glass + iOS 26 SDK; objectVersion 77) |

---

> When a new language, framework, or tool is added to the project, append a row to the relevant table above.
