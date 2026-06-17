Create Swift Testing tests for $ARGUMENTS following project conventions:

- File: `SmartCuberTests/$ARGUMENTSTests.swift`
- Use `import Testing` and `@testable import SmartCuber` — no XCTest, no XCTestCase
- Annotate test methods with `@Test`; use `#expect(...)` and `#require(...)` for assertions
- Method names describe the scenario in plain English: e.g. `solveFormattedDurationOverMinute`
- For SwiftData tests: create an in-memory `ModelContainer` directly inside the test or in a shared `init` if using `@Suite`
- Group related tests under a `@Suite` struct with a descriptive name
- Do not add tests for things that cannot fail (trivial getters, SwiftUI body, etc.)
