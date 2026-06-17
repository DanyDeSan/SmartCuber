# SmartCuber — Practices

Reference document for Git conventions, workflows, and AI agent rules on this project.

---

## Git Conventions

- Default branch: `main`
- Branch naming: `feature/`, `fix/`, `chore/` prefixes
- Commit messages: imperative mood, concise, in English
- Keep LICENSE and README in sync with every significant release

## Workflows

- Feature branches are created from `main` and merged back via PR
- All PRs require a description of what changed and why
- Squash merge preferred to keep history clean

## Documentation Rules

- Any change that affects the overall architecture of the app must be documented in `ARCHITECTURE.md`.
- Any time a design pattern is adopted for a feature or any other purpose, it must be added to the patterns table in `ARCHITECTURE.md` with its location and rationale.
- Any time a new language, framework, or development tool is adopted, it must be documented in `TECHNOLOGIES.md`.
- If a workaround was applied to complete a task, document it in `LESSONS_LEARNED.md` before ending the session (problem, workaround, context).

## AI Agent Rules

- Read `PRACTICES.md`, `ARCHITECTURE.md`, `TECHNOLOGIES.md`, and `LESSONS_LEARNED.md` at the start of every session.
- Follow the stack and conventions defined in `CLAUDE.md`.
- Do not push to `main` directly without user confirmation.
- Do not force-push unless explicitly instructed.
- Prefer non-destructive operations; always confirm before irreversible actions.
