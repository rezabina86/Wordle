import Foundation
@testable import WordleApp

final class GameViewStateConverterMock: GameViewStateConverterType {
    init() {}
    
    public enum Call: Equatable {
        case create(keys: [KeyViewState])
        case create(result: [GameResultEntity])
    }
    
    public var calls: [Call] = []
    public var createFromKeysReturnValue: Word = .empty()
    public var createFromResultReturnValue: Word = .empty()
    
    func create(from keys: [KeyViewState]) -> Word {
        calls.append(.create(keys: keys))
        return createFromKeysReturnValue
    }
    
    func create(from result: [GameResultEntity]) -> Word {
        calls.append(.create(result: result))
        return createFromResultReturnValue
    }

}
