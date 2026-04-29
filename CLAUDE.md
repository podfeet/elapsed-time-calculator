# Elapsed Time Calculator — Claude Context

## Proactive memory
Update this file at the end of every session or whenever a meaningful decision is made, so context is preserved across machines and sessions.

---

## Project goal
Build a native iOS + macOS app called **Elapsed Time Calculator** using SwiftUI (single multiplatform Xcode project). The owner (Allison) has no prior Swift experience — Claude Code is writing the Swift. 

The original web app (HTML/CSS/JS/jQuery/Bootstrap) lives in `web/` for reference. Do not modify it.

---

## About the user
- Allison (@podfeet.com), podcaster, comfortable with web tech but new to Swift and Apple app development
- Prefers Claude Code to write the Swift code; Allison reviews and directs

---

## Key decisions made
- **SwiftUI multiplatform** (not WKWebView wrapper) — native app, single codebase for iOS + macOS
- **Single +/− toggle button per row** (not per field) — the whole row is positive or negative
- **H/M/S fields accept positive numbers and decimals only** — no negative input in fields
- **Math logic ported from** `web/src/timeMath.js` — algorithm must be preserved exactly (see REQUIREMENTS.md)
- **No persistence in v1** — state resets on relaunch
- **No row deletion or reordering in v1**

---

## Current status
- Xcode project fully built and working — all core features implemented
- All tests passing (unit + UI/accessibility) when run on an **iPhone simulator** destination
- Project renamed from `ElapsedTimeAdder` → `ElapsedTimeCalculator` (folder, scheme, targets)

---

## Xcode project layout
```
ElapsedTimeCalculator/                     Xcode project root
  ElapsedTimeCalculator.xcodeproj/
    xcshareddata/xcschemes/
      ElapsedTimeAdder.xcscheme            shared scheme (still named after old project — fine)
  ElapsedTimeCalculator/                   app source
    ElapsedTimeCalculatorApp.swift
    ContentView.swift
    TimeRow.swift                          @Observable model
    TimeRowView.swift                      single row UI + validation
    TimeMath.swift                         port of web/src/timeMath.js
    ExportHelpers.swift                    CSV + HH:MM:SS export
    Assets.xcassets/                       app icon + PodfeetLogo
  ElapsedTimeCalculatorTests/              unit tests
    TimeMathTests.swift
    ValidationTests.swift
    ExportTests.swift
  ElapsedTimeCalculatorUITests/            UI + accessibility tests
    AccessibilityTests.swift
web/          original web app (reference only, do not modify)
REQUIREMENTS.md  full feature spec for the Swift app
CLAUDE.md        this file
```

## Key gotchas discovered
- **Always run tests on an iPhone simulator** — running on "My Mac" destination causes all UI/accessibility tests to report 0 elements found (macOS accessibility tree is different)
- **Parallel UI tests**: scheme has `parallelizable = YES` so Xcode spawns 3 simulator clones; each clone shows the app + a no-icon test runner process — both are normal
- **project.pbxproj uses `PBXFileSystemSynchronizedRootGroup`** — no need to manually register new `.swift` files; Xcode auto-includes everything in the target folders
- **After the project rename**, `TEST_TARGET_NAME` in the UITests build config was still set to `ElapsedTimeAdder`, causing UI tests to silently not run — fixed by updating all stale name references in `project.pbxproj` via `sed`
