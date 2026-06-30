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

## `xcodebuild test` fails with "test runner crashed before establishing connection"

- **Problem**: After several back-to-back `xcodebuild build`/`test` invocations against the same simulator, `xcodebuild test` started failing with `Early unexpected exit, operation never finished bootstrapping... The test runner crashed before establishing connection`. The simulator device had silently transitioned to `Shutdown` (confirmed via `xcrun simctl list devices`) and rebooting that same device didn't fix it.
- **Workaround**: Boot a *different* simulator instance of the same device type (`xcrun simctl boot <other-udid>`) and point `xcodebuild`'s `-destination` at it. Installing and `simctl launch`-ing the app directly on the fresh instance confirmed the app itself launched fine — the failure was the simulator runtime, not a code regression.
- **Context**: Seen when running many rapid `xcodebuild` cycles against one simulator in a single session (e.g. building/testing after every incremental change). Worth checking `simctl list devices` for an unexpectedly `Shutdown` device before assuming a test failure is a real regression.

## Multiple self-sizing controls (Slider, Menu) in one non-scrolling VStack silently clip content above them

- **Problem**: Adding a second `Slider`/`Menu`-style control to `SettingsScreenView`'s non-scrolling two-column layout caused the top of the screen (the "Settings" title and the first row) to render completely missing — not squeezed or overlapping, just absent — while everything below stayed laid out normally. The clipped amount was consistently large (~1 row's worth), reproduced identically across multiple simulators and fresh installs (ruling out simulator/state-cache flakiness), and was **not** caused by any single widget: removing any one card with two such controls (two `Menu`s, or a `Slider` + a `Menu`) fixed it, but no single widget was the culprit in isolation — it only showed up once two or more self-sizing controls coexisted anywhere in the same non-scrolling stack. `TimerTopBar`'s own `Menu` (a single instance, nested in an `HStack` rather than stacked among sibling rows) was unaffected. Verified via screen capture: `xcrun simctl io <device> screenshot` captures the raw framebuffer in the device's *native portrait* orientation even for a landscape-locked app — rotate with `sips -r 270 in.png --out out.png` (or 90, whichever reads right-side-up) before inspecting a screenshot from this app.
- **Workaround**: Wrap the affected content in a `ScrollView` instead of relying on an exact non-scrolling fit. This sidesteps the underlying SwiftUI sizing miscalculation entirely rather than requiring every individual control combination to be identified and avoided — `.fixedSize()`, swapping `Menu`'s internal `Picker(.inline)` for a plain `ForEach`-of-`Button`s, and changing `.menuStyle(...)` all failed to fix it.
- **Context**: `SmartCuber/Features/Settings/SettingsScreenView.swift`. Worth checking for again any time a settings/options-style screen needs two or more `Slider`/`Menu`/similar self-sizing controls stacked as siblings without a `ScrollView` already wrapping them.
