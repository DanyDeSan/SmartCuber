//
//  Solve.swift
//  SmartCuber
//

import Foundation
import SwiftData

/// Represents a single Rubik's cube solve attempt.
@Model
final class Solve {
    var date: Date
    /// Solve duration in seconds. 0 means DNF/not yet recorded.
    var duration: Double
    /// Optional scramble string (e.g. "R U R' U'")
    var scramble: String?
    /// Optional notes (e.g. "PLL skip", "lucky cross")
    var notes: String?

    init(date: Date, duration: Double, scramble: String? = nil, notes: String? = nil) {
        self.date = date
        self.duration = duration
        self.scramble = scramble
        self.notes = notes
    }

    /// Human-readable duration, e.g. "1:23.45" or "45.67"
    var formattedDuration: String {
        guard duration > 0 else { return "DNF" }
        if duration >= 60 {
            let minutes = Int(duration) / 60
            let seconds = duration.truncatingRemainder(dividingBy: 60)
            return String(format: "%d:%05.2f", minutes, seconds)
        } else {
            return String(format: "%.2f", duration)
        }
    }
}
