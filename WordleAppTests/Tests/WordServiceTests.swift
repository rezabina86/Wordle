import Foundation
import XCTest
@testable import Wordle

final class WordServiceTests: XCTestCase {
    var sut: WordService!
    
    func testLoad() throws {
        sut = WordService()
        
        XCTAssertTrue(try sut.load().isEmpty == false)
    }
    
}
