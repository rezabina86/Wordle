import Foundation
import XCTest
@testable import WordleApp

final class ViewModelTests: XCTestCase {
    var sut: ViewModel!
    var wordStorageUseCase: WordStorageUseCaseMock = .init()
    var mockGameService: GameServiceMock = .init()
    var mockViewStateConverter: GameViewStateConverterMock = .init()
    
    func testUserIsTyping() {
        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )
        
        sut.keyTapped = .A
        sut.keyTapped = .B
        sut.keyTapped = .C
        
        XCTAssertTrue(mockViewStateConverter.calls == [
            .create(keys: [.A]),
            .create(keys: [.A, .B]),
            .create(keys: [.A, .B, .C])
        ])
    }
    
    func testSubmitWithCorrectAnswer() {
        wordStorageUseCase.isValidReturnValue = true
        wordStorageUseCase.loadReturnValue = "ABCDE"
        
        let gameResult: [GameResultEntity] = [
            .init(
                status: .correct,
                inputChar: "A"
            ),
            .init(
                status: .correct,
                inputChar: "B"
            ),
            .init(
                status: .correct,
                inputChar: "C"
            ),
            .init(
                status: .correct,
                inputChar: "D"
            ),
            .init(
                status: .correct,
                inputChar: "E"
            )
        ]
        
        mockGameService.checkReturnValue = gameResult
        
        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )
        
        sut.keyTapped = .A
        sut.keyTapped = .B
        sut.keyTapped = .C
        sut.keyTapped = .D
        sut.keyTapped = .E
        
        sut.submit()
        
        XCTAssertTrue(wordStorageUseCase.calls.last == .isValid(word: "ABCDE"))
        
        XCTAssertTrue(mockGameService.calls == [
            .check(
                input: "ABCDE",
                answer: "ABCDE"
            )
        ])
        
        let viewStateExpectation: [GameViewStateConverterMock.Call] = [
            .create(keys: [.A]),
            .create(keys: [.A, .B]),
            .create(keys: [.A, .B, .C]),
            .create(keys: [.A, .B, .C, .D]),
            .create(keys: [.A, .B, .C, .D, .E]),
            .create(result: gameResult)
        ]
        
        XCTAssertTrue(mockViewStateConverter.calls == viewStateExpectation)
        
        XCTAssertTrue(sut.status == .won("Genius"))
    }
    
    func testSubmitWithWrongAnswer() {
        wordStorageUseCase.isValidReturnValue = true
        wordStorageUseCase.loadReturnValue = "ANISE"
        
        let gameResult: [GameResultEntity] = [
            .init(
                status: .wrong,
                inputChar: "P"
            ),
            .init(
                status: .wrong,
                inputChar: "E"
            ),
            .init(
                status: .misplaced,
                inputChar: "A"
            ),
            .init(
                status: .wrong,
                inputChar: "C"
            ),
            .init(
                status: .correct,
                inputChar: "E"
            )
        ]
        
        mockGameService.checkReturnValue = gameResult
        
        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )
        
        sut.keyTapped = .P
        sut.keyTapped = .E
        sut.keyTapped = .A
        sut.keyTapped = .C
        sut.keyTapped = .E
        
        sut.submit()
        
        XCTAssertTrue(wordStorageUseCase.calls.last == .isValid(word: "PEACE"))
        
        XCTAssertTrue(mockGameService.calls == [
            .check(
                input: "PEACE",
                answer: "ANISE"
            )
        ])
        
        let viewStateExpectation: [GameViewStateConverterMock.Call] = [
            .create(keys: [.P]),
            .create(keys: [.P, .E]),
            .create(keys: [.P, .E, .A]),
            .create(keys: [.P, .E, .A, .C]),
            .create(keys: [.P, .E, .A, .C, .E]),
            .create(result: gameResult)
        ]
        
        XCTAssertTrue(mockViewStateConverter.calls == viewStateExpectation)
    }
    
    func testSubmitWithInvalidWord() {
        wordStorageUseCase.isValidReturnValue = false
        wordStorageUseCase.loadReturnValue = "ABCDE"
        
        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )
        
        sut.keyTapped = .A
        sut.keyTapped = .B
        sut.keyTapped = .C
        sut.keyTapped = .F
        sut.keyTapped = .E
        
        sut.submit()
        
        XCTAssertTrue(wordStorageUseCase.calls.last == .isValid(word: "ABCFE"))
        
        XCTAssertTrue(sut.error == .notValidWord)
        
    }
    
    func testSubmitWithNotEnoughCharacter() {
        wordStorageUseCase.isValidReturnValue = false
        wordStorageUseCase.loadReturnValue = "ABCDE"
        
        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )
        
        sut.keyTapped = .A
        sut.keyTapped = .B
        sut.keyTapped = .C
        sut.keyTapped = .D
        
        sut.submit()
        
        XCTAssertTrue(sut.error == .notEnoughChar)
    }
    
    func testGameOver() {
        wordStorageUseCase.isValidReturnValue = true
        wordStorageUseCase.loadReturnValue = "ABCDE"
        
        let gameResult: [GameResultEntity] = [
            .init(
                status: .correct,
                inputChar: "A"
            ),
            .init(
                status: .correct,
                inputChar: "B"
            ),
            .init(
                status: .correct,
                inputChar: "C"
            ),
            .init(
                status: .correct,
                inputChar: "D"
            ),
            .init(
                status: .wrong,
                inputChar: "F"
            )
        ]
        
        mockGameService.checkReturnValue = gameResult

        sut = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: mockGameService,
            viewStateConverter: mockViewStateConverter
        )

        for _ in 0..<6 {
            sut.keyTapped = .A
            sut.keyTapped = .B
            sut.keyTapped = .C
            sut.keyTapped = .D
            sut.keyTapped = .F

            sut.submit()
        }
        
        XCTAssertTrue(sut.status == .finished("ABCDE"))
    }
}
