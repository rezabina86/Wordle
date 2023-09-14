import Foundation

struct Constant {
    static let numberOfRows = 6
    static let numberOfCharacters = 5
}

extension Int {
    var cgFloatValue: CGFloat {
        CGFloat(self)
    }
}
