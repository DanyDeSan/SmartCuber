Create a new SwiftUI view named $ARGUMENTS following project conventions:

- File: `SmartCuber/$ARGUMENTS.swift` (one type per file, name matches the type)
- 2-space indentation, Google Swift Style
- Naming: noun or noun+View (e.g. `TimerView`, `SolveDetailView`)
- Keep `body` thin — extract complex subviews into separate `View` structs (new files if they grow)
- Use `@Environment(\.modelContext)` for mutations, `@Query` for reactive reads
- Include a `#Preview` macro at the bottom; use `inMemory: true` ModelContainer if SwiftData is needed
- If the view needs a ViewModel, create `$ARGUMENTSViewModel.swift` as an `@Observable` class with no SwiftUI imports
- Do not push or present navigation from inside the view — that is the Coordinator's responsibility (see ARCHITECTURE.md)
