import Foundation
@testable import Wordle

final class GameServiceMock: GameServiceType {
    
    init() {}
    
    public enum Call: Equatable {
        case check(input: String, answer: String)
    }
    
    public var calls: [Call] = []
    public var checkReturnValue: [GameResultEntity] = []
    
    func check(input: String, answer: String) -> [GameResultEntity] {
        calls.append(.check(input: input, answer: answer))
        return checkReturnValue
    }
    
}
