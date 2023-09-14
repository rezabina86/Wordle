import Foundation

protocol WordServiceType {
    func load() throws -> [String]
}

final class WordService: WordServiceType {
    func load() throws -> [String] {
        guard let url = Bundle.main.url(forResource: "common", withExtension: "json") else {
            throw WordServiceError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let entity = try JSONDecoder().decode(WordEntity.self, from: data)
        return entity.commonWords
    }
}
