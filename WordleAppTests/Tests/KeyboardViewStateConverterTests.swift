import Foundation
import XCTest
@testable import WordleApp

final class KeyboardViewStateConverterTests: XCTestCase {
    var sut: KeyBoardViewState!
    
    func testWithWord() {
        sut = .create()
        
        let gameResult: [GameResultEntity] = [
            .init(status: .correct, inputChar: "A"),
            .init(status: .wrong, inputChar: "N"),
            .init(status: .misplaced, inputChar: "I"),
            .init(status: .wrong, inputChar: "S"),
            .init(status: .correct, inputChar: "E")
        ]
        
        let expectation: KeyBoardViewState = .init(
            firstRow: [
                .Q, .W, .init(
                    state: .correct,
                    type: .character,
                    char: "E"
                ), .R, .T, .Y, .U, .init(
                    state: .misplaced,
                    type: .character,
                    char: "I"
                ), .O, .P
            ],
            secondRow: [
                .init(
                    state: .correct,
                    type: .character,
                    char: "A"
                ), .init(
                    state: .wrong,
                    type: .character,
                    char: "S"
                ), .D, .F, .G, .H, .J,.K, .L
            ],
            thirdRow: [
                .enter, .Z, .X, .C, .V, .B, .init(
                    state: .wrong,
                    type: .character,
                    char: "N"
                ), .M , .delete
            ]
        )
        
        sut = sut.create(from: gameResult)
        
        XCTAssertTrue(sut == expectation)
        
        // Users continue enter new words
        let gameResult2: [GameResultEntity] = [
            .init(status: .correct, inputChar: "P"),
            .init(status: .wrong, inputChar: "E"),
            .init(status: .misplaced, inputChar: "A"),
            .init(status: .wrong, inputChar: "C"),
            .init(status: .correct, inputChar: "E")
        ]
        
        let expectation2: KeyBoardViewState = .init(
            firstRow: [
                .Q, .W, .init(
                    state: .correct,
                    type: .character,
                    char: "E"
                ), .R, .T, .Y, .U, .init(
                    state: .misplaced,
                    type: .character,
                    char: "I"
                ), .O, .init(
                    state: .correct,
                    type: .character,
                    char: "P"
                )
            ],
            secondRow: [
                .init(
                    state: .correct,
                    type: .character,
                    char: "A"
                ), .init(
                    state: .wrong,
                    type: .character,
                    char: "S"
                ), .D, .F, .G, .H, .J,.K, .L
            ],
            thirdRow: [
                .enter, .Z, .X, .init(
                    state: .wrong,
                    type: .character,
                    char: "C"
                ), .V, .B, .init(
                    state: .wrong,
                    type: .character,
                    char: "N"
                ), .M , .delete
            ]
        )
        
        sut = sut.create(from: gameResult2)
        
        XCTAssertTrue(sut == expectation2)
    }
}

