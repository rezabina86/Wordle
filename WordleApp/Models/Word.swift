import Foundation

struct Word: Equatable, Identifiable {
    let id = UUID()
    var characters: [Char]
    
    static func empty() -> Self {
        .init(
            characters: Array(
                repeating: .empty(),
                count: Constant.numberOfCharacters
            )
        )
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.characters == rhs.characters
    }
    
    struct Char: Equatable, Identifiable {
        let id = UUID()
        let character: Character
        var state: State = .draft
        
        enum State: Equatable {
            case draft
            case correct
            case displaced
            case wrong
        }
        
        static func empty() -> Self {
            .init(character: Character(" "))
        }
        
        var isEmpty: Bool {
            self == .empty()
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.character == rhs.character && lhs.state == rhs.state
        }
    }
}
