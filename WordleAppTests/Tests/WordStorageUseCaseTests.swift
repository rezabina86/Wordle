import Foundation
import XCTest
@testable import Wordle

final class WordStorageUseCaseTests: XCTestCase {
    
    var sut: WordStorageUseCase!
    var mockWordService: WordServiceMock = WordServiceMock()
    
    func testIsValid() {
        mockWordService.loadReturnValue = ["debug", "metro"]
        sut = WordStorageUseCase(wordService: mockWordService)
        
        let input: [(String, Bool)] = [
            ("DEBUG", true),
            ("ANISE", false),
            ("PROXY", false),
            ("METRO", true)
        ]
        
        for (i, expectation) in input {
            XCTAssertTrue(sut.isValid(i) == expectation)
        }
    }
    
    func testLoad() {
        mockWordService.loadReturnValue = ["debug"]
        sut = WordStorageUseCase(wordService: mockWordService)
        
        XCTAssertTrue(sut.load() == "debug")
    }
    
}
