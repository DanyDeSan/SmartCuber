//
//  ScrambleGenerator.swift
//  SmartCuber
//
//  WCA-style face-turn scrambler ported from the design's `genScramble`.
//  Avoids turning the same face twice in a row and three consecutive turns
//  on the same axis.
//

import Foundation

enum ScrambleGenerator {
  private static let faces = ["U", "D", "L", "R", "F", "B"]
  private static let modifiers = ["", "'", "2"]
  /// Axis index per face — U/D share 0, L/R share 1, F/B share 2.
  private static let axis: [String: Int] = [
    "U": 0, "D": 0, "L": 1, "R": 1, "F": 2, "B": 2
  ]

  /// Produces a scramble appropriate for the given puzzle.
  static func generate(for puzzle: Puzzle) -> String {
    generate(length: puzzle.moveCount)
  }

  /// Produces a scramble of `length` face turns.
  static func generate<Generator: RandomNumberGenerator>(
    length: Int,
    using generator: inout Generator
  ) -> String {
    var moves: [String] = []
    var last: String?
    var secondLast: String?

    while moves.count < length {
      let face = faces.randomElement(using: &generator) ?? "U"
      if face == last { continue }
      if let last, let secondLast,
        axis[face] == axis[last], axis[face] == axis[secondLast] {
        continue
      }
      let modifier = modifiers.randomElement(using: &generator) ?? ""
      moves.append(face + modifier)
      secondLast = last
      last = face
    }

    return moves.joined(separator: " ")
  }

  /// Convenience overload using the system random generator.
  static func generate(length: Int) -> String {
    var generator = SystemRandomNumberGenerator()
    return generate(length: length, using: &generator)
  }
}
