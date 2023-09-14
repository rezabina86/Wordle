import Foundation
import XCTest
@testable import WordleApp

final class WordServiceTests: XCTestCase {
    var sut: WordService!
    
    func testLoad() throws {
        sut = WordService()
        
        XCTAssertTrue(try sut.load().isEmpty == false)
    }
    
}
