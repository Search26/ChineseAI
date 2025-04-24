import SwiftUI

@available(iOS 16.0, *)
extension View {
    func hideKeyboardOnTap() -> some View {
        self.gesture(
            TapGesture().onEnded { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }
}
