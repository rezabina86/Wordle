import SwiftUI

struct KeyBoardView: View {
    
    @Binding var onTap: KeyViewState
    let numberOfCharacters: Int
    
    private let viewState: KeyBoardViewState
    
    init(onTap: Binding<KeyViewState>,
         numberOfCharacters: Int = Constant.numberOfCharacters,
         viewState: KeyBoardViewState) {
        self._onTap = onTap
        self.viewState = viewState
        self.numberOfCharacters = numberOfCharacters
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                ForEach(viewState.firstRow) { key in
                    createKey(from: key)
                }
            }
            HStack(spacing: 6) {
                ForEach(viewState.secondRow) { key in
                    createKey(from: key)
                }
            }
            HStack(spacing: 6) {
                ForEach(viewState.thirdRow) { key in
                    createKey(from: key)
                }
            }
        }
    }
    
    @ViewBuilder
    private func createKey(from state: KeyViewState) -> some View {
        switch state.type {
        case .character:
            Button(state.char.uppercased()) {
                onTap = state
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(minWidth:29)
            .frame(height: 50)
            .background(state.state.backgroundColor)
            .cornerRadius(4)
        case .enter:
            Button("ENTER") {
                onTap = state
            }
            .font(.caption2)
            .fontWeight(.bold)
            .scaledToFill()
            .minimumScaleFactor(0.01)
            .padding(8)
            .foregroundColor(.white)
            .frame(height: 50)
            .background(Color.lightGray)
            .cornerRadius(4)
        case .delete:
            Button {
                onTap = state
            } label: {
                Image(systemName: "delete.left")
                    .fontWeight(.bold)
                    .padding(8)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .background(Color.lightGray)
                    .cornerRadius(4)
            }
        }
    }
}

struct KeyBoardViewState: Equatable {
    let firstRow: [KeyViewState]
    let secondRow: [KeyViewState]
    let thirdRow: [KeyViewState]
    
    static func create() -> Self {
        .init(
            firstRow: [
                .Q, .W, .E, .R, .T, .Y, .U, .I, .O, .P
            ],
            secondRow: [
                .A, .S, .D, .F, .G, .H, .J,.K, .L
            ],
            thirdRow: [
                .enter, .Z, .X, .C, .V, .B, .N, .M , .delete
            ]
        )
    }
}

struct KeyViewState: Equatable, Identifiable, Hashable {
    let id = UUID()
    let state: State
    let type: KeyType
    let char: Character
    
    enum State: Equatable {
        case wrong
        case correct
        case misplaced
        case none
    }
    
    enum KeyType: Equatable {
        case character
        case enter
        case delete
    }
    
    static func == (lhs: KeyViewState, rhs: KeyViewState) -> Bool {
        lhs.char == rhs.char
    }
}

extension KeyViewState.State {
    var backgroundColor: Color {
        switch self {
        case .wrong:
            return .darkGray
        case .correct:
            return .correct
        case .misplaced:
            return .misplaced
        case .none:
            return .lightGray
        }
    }
}

struct KeyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyBoardView(
            onTap: .constant(.A),
            viewState: .create()
        )
    }
}

extension KeyViewState {
    
    static let Q: KeyViewState = .init(state: .none, type: .character, char: "Q")
    static let W: KeyViewState = .init(state: .none, type: .character, char: "W")
    static let E: KeyViewState = .init(state: .none, type: .character, char: "E")
    static let R: KeyViewState = .init(state: .none, type: .character, char: "R")
    static let T: KeyViewState = .init(state: .none, type: .character, char: "T")
    static let Y: KeyViewState = .init(state: .none, type: .character, char: "Y")
    static let U: KeyViewState = .init(state: .none, type: .character, char: "U")
    static let I: KeyViewState = .init(state: .none, type: .character, char: "I")
    static let O: KeyViewState = .init(state: .none, type: .character, char: "O")
    static let P: KeyViewState = .init(state: .none, type: .character, char: "P")
    static let A: KeyViewState = .init(state: .none, type: .character, char: "A")
    static let S: KeyViewState = .init(state: .none, type: .character, char: "S")
    static let D: KeyViewState = .init(state: .none, type: .character, char: "D")
    static let F: KeyViewState = .init(state: .none, type: .character, char: "F")
    static let G: KeyViewState = .init(state: .none, type: .character, char: "G")
    static let H: KeyViewState = .init(state: .none, type: .character, char: "H")
    static let J: KeyViewState = .init(state: .none, type: .character, char: "J")
    static let K: KeyViewState = .init(state: .none, type: .character, char: "K")
    static let L: KeyViewState = .init(state: .none, type: .character, char: "L")
    static let Z: KeyViewState = .init(state: .none, type: .character, char: "Z")
    static let X: KeyViewState = .init(state: .none, type: .character, char: "X")
    static let C: KeyViewState = .init(state: .none, type: .character, char: "C")
    static let V: KeyViewState = .init(state: .none, type: .character, char: "V")
    static let B: KeyViewState = .init(state: .none, type: .character, char: "B")
    static let N: KeyViewState = .init(state: .none, type: .character, char: "N")
    static let M: KeyViewState = .init(state: .none, type: .character, char: "M")
    
    static let enter: KeyViewState = .init(state: .none, type: .enter, char: " ")
    static let delete: KeyViewState = .init(state: .none, type: .delete, char: " ")
    
    static let none: KeyViewState = .init(state: .none, type: .delete, char: " ")
}

extension KeyBoardViewState {
    
}
