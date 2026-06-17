# SmartCuber — Lessons Learned

Workarounds and non-obvious solutions applied during development.
Agents must update this file when they apply a workaround to complete a task, so future sessions can resolve the same issue faster.

---

## Format

Each entry should include:
- **Problem**: what went wrong or what was blocking progress.
- **Workaround**: what was done to solve it.
- **Context**: when/where it applies (file, command, tool, etc.).

---

## Git lock files blocking operations

- **Problem**: Git commands failed with `Unable to create '...HEAD.lock'` or `'...index.lock': File exists`, indicating a stale lock from a previously crashed process.
- **Workaround**: Remove all stale lock files with `find <repo>/.git -name "*.lock" -delete`, then retry the git command.
- **Context**: Can happen when Xcode or another git client crashes mid-operation. Safe to delete if no other git process is actively running.
