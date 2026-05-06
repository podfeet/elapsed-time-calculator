//
//  TimeRow.swift
//  ElapsedTimeAdder
//
//  Data model for a single time row.

import Foundation
import Observation

/// A single row of time input in the calculator.
///
/// Each row holds hours, minutes, and seconds as raw strings (allowing partial
/// input like `"1."` while the user is still typing) plus an optional title and
/// a flag indicating whether the row should be subtracted from the running total.
///
/// `TimeRow` is an `@Observable` class so SwiftUI views automatically re-render
/// when any property changes.  It conforms to `Identifiable` via a stable `UUID`
/// so `ForEach` can track rows across additions without index gymnastics.
@Observable
class TimeRow: Identifiable {
    /// Stable identity used by SwiftUI's `ForEach`.
    let id = UUID()

    /// Optional user-supplied label for this row (e.g. `"Morning commute"`).
    var title: String = ""

    /// Raw hours input.  Stored as a `String` to allow partial values like `"1."`.
    var hours: String = ""

    /// Raw minutes input.  Stored as a `String` to allow partial values like `"30."`.
    var minutes: String = ""

    /// Raw seconds input.  Stored as a `String` to allow partial values like `"45."`.
    var seconds: String = ""

    /// When `true` the row's time value is subtracted from the running total;
    /// when `false` it is added.
    var isSubtracting: Bool = false
}
