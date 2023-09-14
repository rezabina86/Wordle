import Foundation
@testable import Wordle

final class WordServiceMock: WordServiceType {
    
    init() {}
    
    public enum Call {
        case load
    }
    
    public var calls: [Call] = []
    public var loadReturnValue: [String] = []
    
    func load() throws -> [String] {
        calls.append(.load)
        return loadReturnValue
    }
    
}
