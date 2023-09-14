import Foundation
import Combine

enum GameStatus: Equatable {
    case ongoing
    case won(String)
    case finished(String)
}

// MARK: - View Model
final class ViewModel: ObservableObject {
    
    // MARK: - Life cycle
    init(
        wordStorageUseCase: WordStorageUseCaseType,
        gameService: GameServiceType,
        viewStateConverter: GameViewStateConverterType
    ){
        self.wordStorageUseCase = wordStorageUseCase
        self.gameService = gameService
        self.viewStateConverter = viewStateConverter
        
        if let answer = wordStorageUseCase.load()?.uppercased() {
            self.answer = answer
            
            $keyTapped
                .sink { [weak self] key in
                    guard let self else { return }
                    error = .none
                    handleInput(for: key)
                }
                .store(in: &subscriptions)
            
        } else {
            self.error = .errorLoadingWord
        }
    }
    
    // MARK: - Publishers
    @Published var error: RowError = .none
    @Published var status: GameStatus = .ongoing
    @Published var keyTapped: KeyViewState = .none
    @Published var keyboardState: KeyBoardViewState = .create()
    
    // Rows
    @Published var rows: [Word] = [
        .empty(),
        .empty(),
        .empty(),
        .empty(),
        .empty(),
        .empty()
    ]
    
    // MARK: - Privates
    private var subscriptions: Set<AnyCancellable> = []
    private var answer: String = ""
    private var currentRow = 0
    private var currentWord: [KeyViewState] = []
    
    private let wordStorageUseCase: WordStorageUseCaseType
    private let gameService: GameServiceType
    private let viewStateConverter: GameViewStateConverterType
    
    private func handleInput(for key: KeyViewState) {
        switch key.type {
        case .character, .delete:
            updateWord(with: key)
        case .enter:
            submit()
        }
    }
    
    private func updateWord(with key: KeyViewState) {
        guard status == .ongoing else { return }
        
        switch key.type {
        case .character:
            guard currentWord.count < Constant.numberOfCharacters else { return }
            currentWord.append(key)
        case .delete:
            guard !currentWord.isEmpty else { return }
            currentWord.removeLast()
        case .enter: break
        }
        
        self.rows[currentRow] = viewStateConverter.create(from: currentWord)
    }
    
    private func handleResult(_ result: [GameResultEntity]) {
        self.rows[currentRow] = viewStateConverter.create(from: result)
        
        currentRow += 1
        currentWord.removeAll()
        
        updateKeyboard(with: result)
        checkIfGameEnded(with: result)
    }

    private func checkIfGameEnded(with result: [GameResultEntity]) {
        if result.didWin {
            status = .won("Congradulations!")
            return
        }

        if currentRow == rows.count {
            status = .finished("The answer is \(answer)")
        }
    }
    
    private func updateKeyboard(with result: [GameResultEntity]) {
        self.keyboardState = self.keyboardState.create(from: result)
    }
    
    // MARK: - Publics
    public func submit() {
        guard case .ongoing = status else { return }
        
        guard currentWord.count == Constant.numberOfCharacters else {
            error = .notEnoughChar
            return
        }
        
        let word = currentWord.compactMap { String($0.char) }.joined()

        guard wordStorageUseCase.isValid(word) else {
            error = .notValidWord
            return
        }

        let result = gameService.check(input: word, answer: answer)
        self.handleResult(result)
    }
    
}

enum RowError {
    case none
    case errorLoadingWord
    case notValidWord
    case notEnoughChar
    
    var description: String? {
        switch self {
        case .none: return nil
        case .errorLoadingWord: return "Can not load the word"
        case .notValidWord: return "Not in word list"
        case .notEnoughChar: return "Not enough letters"
        }
    }
}

extension GameResultEntity.Status {
    var charStatus: Word.Char.State {
        switch self {
        case .correct:
            return .correct
        case .misplaced:
            return .displaced
        case .wrong:
            return .wrong
        }
    }
}

extension Word.Char.State {
    var keyStatus: KeyViewState.State {
        switch self {
        case .correct:
            return .correct
        case .displaced:
            return .misplaced
        case .wrong:
            return .wrong
        case .draft:
            return .none
        }
    }
}

