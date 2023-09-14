import Foundation

public func injectDependencies(into container: ContainerType) {
    
    container.register(in: .weakContainer) { container -> WordServiceType in
        WordService()
    }
    
    container.register(in: .weakContainer) { container -> GameServiceType in
        GameService()
    }
    
    container.register(in: .weakContainer) { container -> WordStorageUseCaseType in
        WordStorageUseCase(wordService: container.resolve())
    }
    
    container.register { container -> GameViewStateConverterType in
        GameViewStateConverter()
    }
    
}
