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
| Value-type presenters | `StatsViewModel`, `SolvesViewModel` | Read-only view models that derive data from a query are structs; only stateful models (`TimerViewModel`) are `@Observable` |
| Native chrome + Liquid Glass | `TabView` (`RootView`) and `Menu`s (`TimerTopBar`) | The tab bar and the puzzle/overflow menus are system controls, so they adopt Liquid Glass automatically; custom card surfaces use `.glassEffect()` |
| `UIViewRepresentable` bridge | `TwoFingerTouchSurface` | Reliable multitouch counting so the timer arms only on two simultaneous touches — something SwiftUI gestures don't express cleanly |
| Active-flag model state | `Session.isActive` | "Which session is recording" is data-layer state co-located with the relationship it governs, not a `TimerSettings` UI preference. SwiftData has no native uniqueness constraint, so "exactly one active" is enforced procedurally in `SessionsViewModel`/`SolveRecorder`, not by the schema |
| Mutable design tokens | `Theme.monoDesign`, `Color.adaptive` (`Color+Hex`) | `Theme`'s colors/fonts are read as plain constants from ~12 call sites with no view context to thread an environment value through. A mutable `monoDesign` token (synced from `TimerSettings.timerFont` in `RootView`) and dynamic `UIColor`-backed adaptive colors let every token react to a Settings change or system appearance without touching any call site — a deliberate, documented trade-off of global mutable state for call-site simplicity |
| Coordinator-owned sheet | Sessions management (`AppCoordinator.isManagingSessions` / `presentSessionsManagement()`, presented from `RootView`) | The app's first modal presentation. Follows the same "method, not direct property mutation" shape as `select(solve:)`; a sheet rather than a push since the app has no `NavigationStack` anywhere else |

> When a new design pattern is adopted for any feature, add a row to this table with where it is used and why.

---

## Project Structure

Source is organized into feature-first modules (see `PRACTICES.md → Project Structure`).
The app target is a file-system-synchronized group, so folders are compiled automatically.

```
SmartCuber/
├── App/                  # SmartCuberApp, RootView (TabView), AppCoordinator, AppTab
├── Models/               # Solve, Session (isActive flag), Penalty, Puzzle
│                         #   (SwiftData @Models + enums)
├── Services/             # ScrambleGenerator, SolveStatistics, SolveRecorder,
│                         #   TimeFormatter, RelativeTime, SolveCSVExporter
├── DesignSystem/         # Theme (adaptive colors + monoDesign), Color+Hex,
│                         #   SolveTagView (shared UI)
├── Support/              # Haptics
├── Features/
│   ├── Timer/            # TimerScreenView, TimerViewModel, TimerPhase (incl.
│   │                     #   .inspecting), TimerTopBar, FingerTargetView,
│   │                     #   FingerprintView, HeroTimeView, TwoFingerTouchSurface
│   ├── Stats/            # StatsScreenView, StatsViewModel, StatCardView
│   ├── Solves/           # SolvesScreenView, SolvesViewModel, SolveDetailPane
│   └── Settings/         # SettingsScreenView, SettingsComponents (SettingsGroup/
│                         #   SettingsRow), TimerSettings, TimerFont, AppAppearance,
│                         #   SessionsScreenView, SessionsViewModel
└── Assets.xcassets/      # App icon + accent color

SmartCuberTests/          # Swift Testing: model, formatter, scramble, statistics,
                          #   penalty, recorder, timer state machine, sessions,
                          #   CSV export, font, and appearance suites
```

> Keep this section in sync with the actual filesystem. Any file or folder added, removed, or reorganized must be reflected here.

---

## Notes

- All `@Model` classes live in `SmartCuber/` alongside views.
- `ModelContainer` is configured once in `SmartCuberApp.swift` and injected via `.modelContainer()`.
- ViewModels are instantiated by their parent Coordinator or parent View — never inside a `@Query` call.
- The app is **landscape-only on iPhone** — the timer is an immersive, full-screen experience (scramble, hero time, two thumb prints) and the Stats/Solves/Settings tabs use wide two-column layouts. The orientation lock lives in the iPhone `INFOPLIST_KEY_UISupportedInterfaceOrientations` build setting.
- `RootView` hosts a **native `TabView`** (Liquid Glass tab bar) and owns the `AppCoordinator`, `TimerSettings` and `TimerViewModel`. Each feature screen owns its own `@Query`; the timer hides the tab bar while running for an immersive solve.
- **Minimum deployment is iOS 26** so the app can adopt Liquid Glass throughout (native `TabView`/`Menu`s plus `.glassEffect()` on custom card surfaces).
- **No seeded/sample data.** A fresh install starts empty; the Stats and Solves tabs render explicit empty states, and the first finished solve lazily creates the "Casual" session via `SolveRecorder`.
- **Appearance follows the system by default.** `RootView` no longer hardcodes `.preferredColorScheme(.dark)` — it reads `TimerSettings.appearance` (`AppAppearance`), which is `nil` (no override) for the default "System" case, so the app inherits the device's light/dark setting. The Settings tab's Appearance picker can still force Light or Dark explicitly.
- **The timer's WCA inspection countdown reuses the same two-finger gesture**, not a new one. After arming, releasing starts a 15-second inspection (`TimerPhase.inspecting`) instead of the solve clock when `TimerSettings.inspectionEnabled` is on; touching again re-arms, and the next release starts the real clock with an automatic +2 (15–17s) / DNF (17s+) penalty computed from the inspection's elapsed time.
