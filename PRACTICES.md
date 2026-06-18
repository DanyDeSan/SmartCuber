# SmartCuber — Practices

Reference document for Git conventions, workflows, and AI agent rules on this project.

---

## Code Style

- Indentation: **2 spaces** (Google Swift Style Guide). Configure Xcode manually: **Xcode → Settings → Text Editing → Indentation → Prefer indent using: Spaces, Width: 2**.
- All Swift files are linted with SwiftLint on every edit (`.swiftlint.yml` at project root).

## Git Conventions

- Default branch: `main`
- Branch naming: `feature/`, `fix/`, `chore/` prefixes
- Commit messages: imperative mood, concise, in English
- Keep LICENSE and README in sync with every significant release

## Workflows

- At the **start of every session**, the first task is to fetch the latest `main` and create the development branch from there (`git fetch origin main && git switch -c <prefix>/<name> origin/main`). Do not branch off a stale local `main`.
- Feature branches are created from `main` and merged back via PR
- To bring `main`'s changes into a development branch, **rebase, do not merge** (`git fetch origin main && git rebase origin/main`). This keeps a linear history and avoids merge commits on feature branches.
- All PRs require a description of what changed and why
- Squash merge preferred to keep history clean

## Documentation Rules

- Any change that affects the overall architecture of the app must be documented in `ARCHITECTURE.md`.
- The current project file/folder structure must always be reflected in `ARCHITECTURE.md`. Any time a file or folder is added, removed, or reorganized, update the structure section there.
- Any time a design pattern is adopted for a feature or any other purpose, it must be added to the patterns table in `ARCHITECTURE.md` with its location and rationale.
- Any time a new language, framework, or development tool is adopted, it must be documented in `TECHNOLOGIES.md`.
- If a workaround was applied to complete a task, document it in `LESSONS_LEARNED.md` before ending the session (problem, workaround, context).

## AI Agent Rules

- Read `PRACTICES.md`, `ARCHITECTURE.md`, `TECHNOLOGIES.md`, and `LESSONS_LEARNED.md` at the start of every session.
- Follow the stack and conventions defined in `CLAUDE.md`.
- Do not push to `main` directly without user confirmation.
- Do not force-push unless explicitly instructed.
- Prefer non-destructive operations; always confirm before irreversible actions.
