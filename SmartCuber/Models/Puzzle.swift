//
//  Puzzle.swift
//  SmartCuber
//
//  The puzzles offered by the top-bar picker. `moveCount` drives the
//  scramble generator's length for the cube puzzles.
//

import Foundation

enum Puzzle: String, Codable, CaseIterable, Identifiable {
  case twoByTwo
  case threeByThree
  case fourByFour
  case fiveByFive
  case pyraminx
  case skewb
  case megaminx
  case squareOne

  var id: String { rawValue }

  /// The label rendered in the picker and top-bar chip (e.g. "3×3").
  var label: String {
    switch self {
    case .twoByTwo: return "2×2"
    case .threeByThree: return "3×3"
    case .fourByFour: return "4×4"
    case .fiveByFive: return "5×5"
    case .pyraminx: return "Pyraminx"
    case .skewb: return "Skewb"
    case .megaminx: return "Megaminx"
    case .squareOne: return "Square-1"
    }
  }

  /// Number of moves the scramble generator produces. Only the WCA cube
  /// puzzles use the face-turn generator; others fall back to a short length.
  var moveCount: Int {
    switch self {
    case .twoByTwo: return 11
    case .threeByThree: return 20
    case .fourByFour: return 40
    case .fiveByFive: return 60
    default: return 15
    }
  }
}
