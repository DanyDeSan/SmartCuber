# SmartCuber

iOS app for tracking Rubik's cube solves — times, scrambles, stats, and analysis.

## Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI + Liquid Glass |
| Persistence | SwiftData |
| Testing | Swift Testing (`import Testing`) — **no XCTest** |
| Language | Swift 5.x |
| Minimum deployment | iOS 26.0 (required for Liquid Glass) |
| Bundle ID | `com.dany.SmartCuber` |
| Dev team | `RRULW6ZM98` |

## Project Structure

Source is organized into feature-first modules (folders are compiled automatically by
the file-system-synchronized group). See `PRACTICES.md → Project Structure` for the rules.

```
SmartCuber/
├── App/                  # SmartCuberApp, RootView (native TabView), AppCoordinator, AppTab
├── Models/               # Solve, Session, Penalty, Puzzle
├── Services/             # ScrambleGenerator, SolveStatistics, SolveRecorder, TimeFormatter, …
├── DesignSystem/         # Theme, Color+Hex, SolveTagView
├── Support/              # Haptics
├── Features/             # Timer / Stats / Solves / Settings (each: screen + view model + subviews)
└── Assets.xcassets/      # App icon + accent color
SmartCuberTests/          # Swift Testing suites
```

## Key Conventions

### SwiftData

- All `@Model` classes live in `SmartCuber/Models/`.
- `ModelContainer` is configured once in `SmartCuberApp.swift` and injected via `.modelContainer()`.
- Use `@Query` in views for reactive data fetching; use `@Environment(\.modelContext)` for mutations.
- Keep models small and focused. Complex business logic goes in extensions, not inside the model class.

### SwiftUI

- Navigation is coordinator-driven via `AppCoordinator`. Views never push or present directly.
- Extract list rows and detail views into separate `View` structs — don't nest complex bodies.
- Use `#Preview` macros with `inMemory: true` model containers for previews.

### Swift Testing

- Test files use `import Testing` and `@testable import SmartCuber`.
- Test methods use `@Test` attribute; assertions use `#expect(...)` and `#require(...)`.
- No `XCTestCase`, no `setUp`/`tearDown` — use Swift Testing's `@Suite` + `init`/`deinit` if needed.
- For SwiftData tests, create an in-memory `ModelContainer` directly in the test.

### Naming

- SwiftData models: singular noun, PascalCase (`Solve`, `Session`, `Algorithm`)
- Views: noun or noun+View (`ContentView`, `SolveDetailView`, `TimerView`)
- View models / observable objects: noun+ViewModel if needed

### File Organization

- One Swift type per file, file name matches the type name.
- No storyboards, no XIBs, no UIKit unless absolutely necessary.

## Domain Concepts

The app revolves around:
- **Solve** — a single timed attempt. Has `duration` (seconds as `Double`), `date`, optional `scramble` string, and optional `notes`.
- Future: **Session** — a group of solves in one sitting.
- Future: **Algorithm** — a saved OLL/PLL or other algorithm with moves and description.

## Git

Committed by: Dany (ldanieldesanpedro@gmail.com)  
Ignore rules in `.gitignore` cover: DerivedData, xcuserdata, .DS_Store, SPM build artifacts, Pods, Carthage/Build, Fastlane output.

## Running the Project

Open `SmartCuber.xcodeproj` in Xcode 16+ (objectVersion 77 requires Xcode 16).  
Select an iPhone simulator or device, press ⌘R.

Run tests: ⌘U — uses Swift Testing, results appear in the Test Navigator.
