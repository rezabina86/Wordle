import Foundation

struct GameResultEntity: Hashable, Equatable {
    public  var status    : Status
    public  let inputChar : Character
    
    enum Status: String, Hashable {
        case correct
        case misplaced
        case wrong
    }
}

extension Collection where Iterator.Element == GameResultEntity {
    var didWin: Bool {
        guard !self.isEmpty else { return false }
        var result = true
        self.map { $0.status }
            .forEach { s in
                switch s {
                case .correct: break
                case .misplaced, .wrong:
                    result = false
                }
            }
        return result
    }
}
