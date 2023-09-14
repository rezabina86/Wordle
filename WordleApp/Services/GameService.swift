import Foundation

enum GameServiceError: Error {
    case invalidWord
}

protocol GameServiceType {
    func check(input: String, answer: String) -> [GameResultEntity]
}

struct GameService: GameServiceType {
    
    func check(input: String, answer: String) -> [GameResultEntity] {
        guard input.count == answer.count else { return [] }
        
        var finalResult: [GameResultEntity] = []
        var currentIndex = input.startIndex
        
        // Make the draft result
        while currentIndex < input.endIndex {
            let status: GameResultEntity.Status
            
            if input[currentIndex] == answer[currentIndex] {
                status = .correct
            } else {
                if answer.contains(input[currentIndex]) {
                    status = .misplaced
                } else {
                    status = .wrong
                }
            }
            
            finalResult.append(
                .init(
                    status: status,
                    inputChar: input[currentIndex]
                )
            )
            currentIndex = input.index(after: currentIndex)
        }
        
        // Clean up misplaced
        var misplaced: Set<GameResultEntity> = Set(finalResult.filter({ $0.status == .misplaced }))
        
        while let misplace = misplaced.first {
            let numberInAnswer = answer.filter({ $0 == misplace.inputChar }).count
            let numberInInput  = finalResult.filter({ $0.inputChar == misplace.inputChar }).count
            let numberOfMisplaced = finalResult.filter({ $0 == misplace }).count
            let numberOfCorrects = finalResult.filter( { $0.inputChar == misplace.inputChar && $0.status == .correct } ).count
            
            if numberInInput > numberInAnswer {
                let diff = numberOfMisplaced - (numberInAnswer - numberOfCorrects)
                for _ in 0..<diff {
                    if let i = finalResult.firstIndex(of: misplace) {
                        finalResult[i] = .init(
                            status: .wrong,
                            inputChar: misplace.inputChar
                        )
                    }
                }
            }
            
            misplaced.remove(misplace)
        }
        
        // Return the result
        return finalResult
    }
    
}
