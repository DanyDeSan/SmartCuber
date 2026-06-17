Create a new SwiftData `@Model` class named $ARGUMENTS following project conventions:

- File: `SmartCuber/$ARGUMENTS.swift` (one type per file)
- 2-space indentation, Google Swift Style
- Singular noun, PascalCase name
- Keep the class small and focused — complex logic goes in an extension below the class in the same file
- Properties: simple types only; use SwiftData relationship macros (`@Relationship`) if needed
- Include a memberwise `init` with all non-optional properties; optional properties default to `nil`
- Register the new model in `SmartCuberApp.swift` inside the `Schema([...])` array
- Update `ARCHITECTURE.md` if the model introduces a new relationship pattern
