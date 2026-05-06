# ``ElapsedTimeAdder``

Add and subtract elapsed times the way spreadsheets can't.

## Overview

Elapsed Time Adder is a native SwiftUI app for iOS and macOS that lets you
add and subtract durations — something spreadsheet apps like Excel, Numbers, and
Google Sheets cannot do correctly because they treat time as a clock position
rather than an elapsed quantity.

Each row accepts hours, minutes, and seconds. A **+/−** toggle marks the row as
an addition or subtraction. The running total updates as you type.

### Architecture

The app follows a straightforward SwiftUI data-flow pattern:

- ``TimeRow`` — the `@Observable` model that backs each input row.
- ``calcTotal(rows:)`` — pure function that converts rows to a signed total.
- ``TimeResult`` — value type returned by `calcTotal`, holding the decomposed
  hours / minutes / seconds of the result.
- ``isValidTimeInput(_:)`` — validates raw field strings; drives the per-row
  error state in the UI.
- ``csvString(rows:total:)`` and ``hhmmssString(rows:total:)`` — format the
  current state for export via the system share sheet.

The UI layer (`ContentView`, `TimeRowView`) is intentionally undocumented here;
it contains no public API and is best understood by reading the source directly
alongside the layout notes in `CLAUDE.md`.

### Math algorithm

The core calculation is a direct port of `calcTotal()` from the original web app
(`web/src/timeMath.js`).  Each row is converted to a signed number of total
seconds, summed, then decomposed back into hours / minutes / seconds using
`floor()` arithmetic.  Negative totals are handled by working in absolute-value
space and reapplying the sign at the end — see ``calcTotal(rows:)`` for details.

## Topics

### Model

- ``TimeRow``

### Calculation

- ``calcTotal(rows:)``
- ``TimeResult``
- ``isValidTimeInput(_:)``
- ``zeroIfBlank(_:)``

### Export

- ``csvString(rows:total:)``
- ``hhmmssString(rows:total:)``
