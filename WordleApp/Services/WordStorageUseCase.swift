import Foundation

protocol WordStorageUseCaseType {
    func load() -> String?
    func isValid(_ word: String) -> Bool
}

final class WordStorageUseCase: WordStorageUseCaseType {
    
    // MARK: - Lifecycle
    
    init(wordService: WordServiceType) {
        let wordList = (try? wordService.load()) ?? []
        self.words = Set(wordList)
    }
    
    // MARK: - Privates
    private let words: Set<String>
    
    // MARK: - Publics
    
    func load() -> String? {
        words.randomElement()
    }
    
    func isValid(_ word: String) -> Bool {
        words.contains(word.lowercased())
    }
    
}
