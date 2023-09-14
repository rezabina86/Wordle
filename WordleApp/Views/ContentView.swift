import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(wordStorageUseCase: WordStorageUseCaseType,
         gameService: GameServiceType,
         viewStateConverter: GameViewStateConverterType) {
        self.viewModel = ViewModel(
            wordStorageUseCase: wordStorageUseCase,
            gameService: gameService,
            viewStateConverter: viewStateConverter
        )
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                GeometryReader { proxy in
                    buildRows(with: viewModel.rows, proxy: proxy)
                }
                .padding()
                
                Spacer()
                buildKeyBoardView()
            }
            
            
            VStack {
                buildErrorView()
                Spacer()
            }
            VStack {
                buildBannerView()
                Spacer()
            }
        }
        .padding(16)
        .background(Color.noir)
    }
    
    @ViewBuilder
    private func buildRows(with rows: [Word],
                           proxy: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
                .frame(height: 60)
            let availableWidth = proxy.size.width - (5 * (Constant.numberOfCharacters - 1).cgFloatValue)
            let size = availableWidth / Constant.numberOfCharacters.cgFloatValue
            ForEach(rows) { word in
                HStack(spacing: 5) {
                    ForEach(word.characters) { c in
                        CellView(
                            character: c,
                            width: size,
                            height: size
                        )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildErrorView() -> some View {
        if let msg = viewModel.error.description {
            bannerView(with: msg)
        }
    }
    
    @ViewBuilder
    private func buildBannerView() -> some View {
        switch viewModel.status {
        case let .finished(msg):
            bannerView(with: msg)
        case let .won(msg):
            bannerView(with: msg)
        case .ongoing: EmptyView()
        }
    }
    
    @ViewBuilder
    private func bannerView(with message: String) -> some View {
        Text(message)
            .font(.callout)
            .padding()
            .foregroundColor(.noir)
            .background(Color.white)
            .cornerRadius(8)
    }
    
    @ViewBuilder
    private func buildKeyBoardView() -> some View {
        KeyBoardView(
            onTap: $viewModel.keyTapped,
            viewState: viewModel.keyboardState
        )
    }
    
}

struct CellView: View {
    let character: Word.Char
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Text(String(character.character).uppercased())
            .font(.title)
            .fontWeight(.bold)
            .frame(width: width, height: height)
            .background(background)
            .cellBorderView(for: character)
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    private func borderView() -> some View {
        switch character.state {
        case .correct, .wrong, .displaced: self
        case .draft: self.border(Color.darkGray, width: 3)
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch character.state {
        case .correct: Color.correct
        case .displaced: Color.misplaced
        case .draft: Color.noir
        case .wrong: Color.darkGray
        }
    }
}

private extension View {
    @ViewBuilder
    func cellBorderView(for character: Word.Char) -> some View {
        switch character.state {
        case .correct, .wrong, .displaced: self
        case .draft: self.border(Color.darkGray, width: 3)
        }
    }
}
