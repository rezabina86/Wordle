import SwiftUI

@main
struct WordleApp: App {
    var configureDependencies = injectDependencies
    private let container: ContainerType
    
    init() {
        self.container = Container()
        configureDependencies(container)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                wordStorageUseCase: container.resolve(),
                gameService: container.resolve(),
                viewStateConverter: container.resolve()
            )
        }
    }
}
