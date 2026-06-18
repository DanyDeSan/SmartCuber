# SmartCuber — Architecture

This document describes the architectural decisions and design patterns used in the app.
Any structural change or new pattern adoption must be documented here.

---

## Overall Architecture: MVVM + Coordinator

The app follows **MVVM (Model-View-ViewModel)** combined with the **Coordinator** pattern.

| Layer | Responsibility |
|---|---|
| **Model** | SwiftData `@Model` classes. Pure data and domain logic, no UI dependencies. |
| **ViewModel** | `@Observable` classes that prepare data for views and handle user intent. No SwiftUI imports. |
| **View** | SwiftUI views. Purely declarative. Reads from ViewModel, delegates actions back. |
| **Coordinator** | Manages navigation flow. Owns route decisions; views never push/present directly. |

### Rationale
- MVVM keeps views thin and logic testable without a UI host.
- Coordinator centralizes navigation, avoiding deeply nested `NavigationLink` logic in views and making flow changes easy to reason about.

---

## Design Patterns

| Pattern | Where used | Reason |
|---|---|---|
| Coordinator | App-wide navigation (`AppCoordinator`, `AppTab`) | Decouples views from navigation decisions; views read the selected tab/solve and delegate changes back |
| Finite state machine | Timer ritual (`TimerViewModel` / `TimerPhase`) | Models the idle → holding → ready → running → stopped lifecycle explicitly so transitions and side effects (haptics, clock) are unambiguous |
| Design tokens | Theming (`Theme`, `Color+Hex`) | A single source of truth for the palette/typography keeps every screen in sync with the source design |
| Callback injection | `TimerViewModel.onSolveCompleted` | Lets the timer record solves and learn PB status without importing SwiftData, keeping the ViewModel persistence-agnostic |

> When a new design pattern is adopted for any feature, add a row to this table with where it is used and why.

---

## Notes

- All `@Model` classes live in `SmartCuber/` alongside views (see `CLAUDE.md` for project structure).
- `ModelContainer` is configured once in `SmartCuberApp.swift` and injected via `.modelContainer()`.
- ViewModels are instantiated by their parent Coordinator or parent View — never inside a `@Query` call.
- The app is **landscape-only on iPhone** — the timer is an immersive, full-screen experience (scramble, hero time, two thumb prints) and the Stats/Solves/Settings tabs use wide two-column layouts. The orientation lock lives in the iPhone `INFOPLIST_KEY_UISupportedInterfaceOrientations` build setting.
- `RootView` replaces the original split-view `ContentView` as the app root: it owns the `AppCoordinator`, `TimerSettings` and `TimerViewModel`, renders the selected tab, and wires `SolveRecorder` into the timer.
