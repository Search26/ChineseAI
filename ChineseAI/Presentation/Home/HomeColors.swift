import SwiftUI

@available(iOS 16.0, *)
extension Color {
    static let homeBackground = Color.white
    static let homePrimary = Color(hex: "8B5CF6") // purple
    static let homeSecondaryOrange = Color(hex: "F97316")
    static let homeSecondaryRed = Color(hex: "EF4444")
    static let homeText = Color.black
    static let homeGray = Color(hex: "9CA3AF")
    static let homeBorder = Color(hex: "E5E7EB")
}

@available(iOS 16.0, *)
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
