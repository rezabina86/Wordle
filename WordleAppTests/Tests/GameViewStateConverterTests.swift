import Foundation
import XCTest
@testable import Wordle

final class GameViewStateConverterTests: XCTestCase {
    var sut: GameViewStateConverter!
    
    // MARK: - Words: String
    func testPartialCompleteWord() {
        sut = .init()
        let expectation: Word = .init(
            characters: [
                .init(character: "A"),
                .init(character: "N"),
                .init(character: "I"),
                .empty(),
                .empty()
            ]
        )
        
        let result = sut.create(from: [.A, .N, .I])
        XCTAssertTrue(result == expectation)
    }
    
    func testCompleteWord() {
        sut = .init()
        let expectation: Word = .init(
            characters: [
                .init(character: "A"),
                .init(character: "N"),
                .init(character: "I"),
                .init(character: "S"),
                .init(character: "E"),
            ]
        )

        let result = sut.create(from: [.A, .N, .I, .S, .E])
        XCTAssertTrue(result == expectation)
    }

    func testWordsWithMoreThanFiveCharacters() {
        sut = .init()
        let expectation: Word = .init(
            characters: [
                .init(character: "C"),
                .init(character: "H"),
                .init(character: "R"),
                .init(character: "O"),
                .init(character: "M"),
            ]
        )

        let result = sut.create(from: [.C, .H, .R, .O, .M, .E])
        XCTAssertTrue(result == expectation)
    }

    func testCompleteWordWithRepeatedCharacters() {
        sut = .init()
        let expectation: Word = .init(
            characters: [
                .init(character: "P"),
                .init(character: "E"),
                .init(character: "A"),
                .init(character: "C"),
                .init(character: "E"),
            ]
        )

        let result = sut.create(from: [.P, .E, .A, .C, .E])
        XCTAssertTrue(result == expectation)
    }

    // MARK: - Game result
    func testWithGameResult() {
        sut = .init()
        let expectation: Word = .init(
            characters: [
                .init(character: "P", state: .correct),
                .init(character: "E", state: .wrong),
                .init(character: "A", state: .displaced),
                .init(character: "C", state: .wrong),
                .init(character: "E", state: .correct),
            ]
        )

        let gameResult: [GameResultEntity] = [
            .init(status: .correct, inputChar: "P"),
            .init(status: .wrong, inputChar: "E"),
            .init(status: .misplaced, inputChar: "A"),
            .init(status: .wrong, inputChar: "C"),
            .init(status: .correct, inputChar: "E"),
        ]

        let result = sut.create(from: gameResult)
        XCTAssertTrue(result == expectation)
    }
}
