import SwiftUI

@available(iOS 16.0, *)
extension Font {
    static func rubik(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Rubik", size: size).weight(weight)
    }
}
