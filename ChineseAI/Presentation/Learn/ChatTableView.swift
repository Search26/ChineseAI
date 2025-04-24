import SwiftUI

@available(iOS 16.0, *)
struct ChatTableView: View {
    @Binding var messages: [ChatMessage]
    @Binding var showPinyinFor: UUID?
    var loadMore: () -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(messages) { message in
                    ChatBubbleRow(message: message, showPinyin: showPinyinFor == message.id) {
                        withAnimation { showPinyinFor = (showPinyinFor == message.id) ? nil : message.id }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onAppear {
                    // Load more when first message appears (scroll up)
                    if messages.first == messages.first {
                        loadMore()
                    }
                }
            }
            .listStyle(.plain)
            .padding(.vertical, 4)
        }
    }
}

@available(iOS 16.0, *)
struct ChatBubbleRow: View {
    let message: ChatMessage
    let showPinyin: Bool
    let onTap: () -> Void
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isUser {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.homePrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(message.text)
                    .font(.rubik(size: 16))
                    .foregroundColor(message.isUser ? .white : .homeText)
                    .padding(10)
                    .background(message.isUser ? Color.blue : Color(.systemGray6))
                    .cornerRadius(12)
                    .onTapGesture { onTap() }
                if showPinyin, let pinyin = message.pinyin {
                    Text(pinyin)
                        .font(.rubik(size: 13))
                        .foregroundColor(.homePrimary)
                        .padding(.leading, 10)
                }
            }
            if message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
    }
}
