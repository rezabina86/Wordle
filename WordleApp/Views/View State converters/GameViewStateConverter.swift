import Foundation

protocol GameViewStateConverterType {
    func create(from keys: [KeyViewState]) -> Word
    func create(from result: [GameResultEntity]) -> Word
}

struct GameViewStateConverter: GameViewStateConverterType {
    
    func create(from keys: [KeyViewState]) -> Word {
        var characters: [Word.Char] = []
        let slicedKeys = keys.prefix(Constant.numberOfCharacters)

        for keyState in slicedKeys {
            let char = keyState.char
            characters.append(.init(character: char))
        }

        // If number of characters is less than `Word.numberOfCharacters`,
        // fill the rest with `.empty()`
        for _ in slicedKeys.count..<Constant.numberOfCharacters {
            characters.append(.empty())
        }

        return .init(characters: characters)
    }
    
    func create(from result: [GameResultEntity]) -> Word {
        let characters = result.map { entity in
            Word.Char(character: entity.inputChar, state: entity.status.charStatus)
        }
        return .init(characters: characters)
    }
    
}
