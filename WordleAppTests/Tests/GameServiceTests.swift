import Foundation
import XCTest
@testable import WordleApp

final class GameServiceTests: XCTestCase {
    
    var sut: GameService!
    var mockWordService: WordServiceMock = .init()
    
    func testValidInput() {
        let answer = "ANISE"
        let input = "ANISE"
        sut = GameService()
        
        let expectation: [GameResultEntity] = input.map { char in
            return GameResultEntity(status: .correct, inputChar: char)
        }
        
        let result = sut.check(input: input, answer: answer)
        XCTAssertTrue(result == expectation)
    }
    
    func testValidInputButWrongAnswer1() {
        let answer = "ANISE"
        let input = "WHACK"
        
        sut = GameService()
        
        let expectation: [GameResultEntity] = [
            .init(status: .wrong, inputChar: "W"),
            .init(status: .wrong, inputChar: "H"),
            .init(status: .misplaced, inputChar: "A"),
            .init(status: .wrong, inputChar: "C"),
            .init(status: .wrong, inputChar: "K")
        ]
        
        let result = sut.check(input: input, answer: answer)
        XCTAssertTrue(result == expectation)
    }
    
    func testValidInputButWrongAnswer2() {
        let answer = "ANISE"
        let input = "PEACE"
        
        sut = GameService()
        
        let expectation: [GameResultEntity] = [
            .init(status: .wrong, inputChar: "P"),
            .init(status: .wrong, inputChar: "E"),
            .init(status: .misplaced, inputChar: "A"),
            .init(status: .wrong, inputChar: "C"),
            .init(status: .correct, inputChar: "E")
        ]
        
        let result = sut.check(input: input, answer: answer)
        XCTAssertTrue(result == expectation)
    }
}
