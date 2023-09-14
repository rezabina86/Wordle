import Foundation
@testable import WordleApp

final class WordStorageUseCaseMock: WordStorageUseCaseType {
    
    init() {}
    
    public enum Call: Equatable {
        case load
        case isValid(word: String)
    }
    
    public var calls: [Call] = []
    public var loadReturnValue: String = ""
    public var isValidReturnValue: Bool = false
    
    func load() -> String? {
        calls.append(.load)
        return loadReturnValue
    }
    
    func isValid(_ word: String) -> Bool {
        calls.append(.isValid(word: word))
        return isValidReturnValue
    }
    
}
