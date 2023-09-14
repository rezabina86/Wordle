import Foundation

extension KeyBoardViewState {
    func create(from result: [GameResultEntity]) -> KeyBoardViewState {
        var firstRow = self.firstRow
        var secondRow = self.secondRow
        var thirdRow = self.thirdRow
        
    outer: for entity in result {
        let state = entity.status.charStatus.keyStatus
        let char = entity.inputChar
        
        if let elementIndex = firstRow.firstIndex(where: { $0.char == char }) {
            let element = firstRow[elementIndex]
            if element.state == .correct {
                continue outer
            } else {
                firstRow[elementIndex] = .init(
                    state: state,
                    type: .character,
                    char: element.char
                )
            }
            continue outer
        }
        
        if let elementIndex = secondRow.firstIndex(where: { $0.char == char }) {
            let element = secondRow[elementIndex]
            if element.state == .correct {
                continue outer
            } else {
                secondRow[elementIndex] = .init(
                    state: state,
                    type: .character,
                    char: element.char
                )
            }
            continue outer
        }
        
        if let elementIndex = thirdRow.firstIndex(where: { $0.char == char }) {
            let element = thirdRow[elementIndex]
            if element.state == .correct {
                continue outer
            } else {
                thirdRow[elementIndex] = .init(
                    state: state,
                    type: .character,
                    char: element.char
                )
            }
            continue outer
        }
    }
        
        return .init(
            firstRow: firstRow,
            secondRow: secondRow,
            thirdRow: thirdRow
        )
    }
}
