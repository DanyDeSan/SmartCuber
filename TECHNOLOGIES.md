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
| SwiftData | Persistence — model definition, storage, and reactive queries |
| Swift Observation | Reactive state via `@Observable` (view models, coordinator, settings) — **Combine is not used** |
| Swift Concurrency | Async work via `async`/`await` and `Task`; the timer clock + arm countdown use `Task.sleep` — **Combine is not used** |
| UIKit | Haptic feedback (`UIFeedbackGenerator`) and the scramble clipboard only |
| Swift Testing | Unit testing (`@Test`, `#expect`, `#require`) |

## Tools

| Tool | Purpose |
|---|---|
| Xcode 16+ | IDE and build system (objectVersion 77 requires Xcode 16) |

---

> When a new language, framework, or tool is added to the project, append a row to the relevant table above.
