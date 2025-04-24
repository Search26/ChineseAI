import SwiftUI

@available(iOS 16.0, *)
struct ChatInputView: View {
    @Binding var text: String
    var onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("Type a message...", text: $text)
                .font(.rubik(size: 15))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(text.isEmpty ? Color(.systemGray3) : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}
