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
| Coordinator | App-wide navigation | Decouples views from navigation decisions |

> When a new design pattern is adopted for any feature, add a row to this table with where it is used and why.

---

## Notes

- All `@Model` classes live in `SmartCuber/` alongside views (see `CLAUDE.md` for project structure).
- `ModelContainer` is configured once in `SmartCuberApp.swift` and injected via `.modelContainer()`.
- ViewModels are instantiated by their parent Coordinator or parent View — never inside a `@Query` call.
