//
//  ScrambleGeneratorTests.swift
//  SmartCuberTests
//

@testable import SmartCuber
import Testing

struct ScrambleGeneratorTests {
  private let faces: Set<Character> = ["U", "D", "L", "R", "F", "B"]
  private let axis: [Character: Int] = ["U": 0, "D": 0, "L": 1, "R": 1, "F": 2, "B": 2]

  @Test func producesRequestedLength() {
    let moves = ScrambleGenerator.generate(length: 20).split(separator: " ")
    #expect(moves.count == 20)
  }

  @Test func puzzleLengthsMatchMoveCount() {
    for puzzle in Puzzle.allCases {
      let count = ScrambleGenerator.generate(for: puzzle).split(separator: " ").count
      #expect(count == puzzle.moveCount)
    }
  }

  @Test func tokensAreValidFacesAndModifiers() {
    let valid: Set<String> = ["", "'", "2"]
    for token in ScrambleGenerator.generate(length: 40).split(separator: " ") {
      let face = token.first
      let modifier = String(token.dropFirst())
      #expect(face.map(faces.contains) == true)
      #expect(valid.contains(modifier))
    }
  }

  @Test func neverRepeatsFaceOrTripleAxis() {
    // Repeat across many scrambles to exercise the rejection rules.
    for _ in 0..<200 {
      let moves = ScrambleGenerator.generate(length: 25)
        .split(separator: " ")
        .compactMap(\.first)
      for index in moves.indices {
        if index >= 1 {
          #expect(moves[index] != moves[index - 1])
        }
        if index >= 2 {
          let sameAxis = axis[moves[index]] == axis[moves[index - 1]]
            && axis[moves[index]] == axis[moves[index - 2]]
          #expect(!sameAxis)
        }
      }
    }
  }
}
