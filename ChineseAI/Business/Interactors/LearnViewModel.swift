import Foundation
import Combine

@available(iOS 16.0, *)
final class LearnViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(isUser: false, text: "你好！我是你的中文老师。", showPinyin: false),
        ChatMessage(isUser: true, text: "Hello! I want to practice.", showPinyin: false)
    ]
    @Published var tutorMode: TutorMode = .zh
    private var canLoadMore = true
    
    func sendMessage(text: String) {
        guard !text.isEmpty else { return }
        messages.append(ChatMessage(isUser: true, text: text, showPinyin: false))
        // Placeholder for AI reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(ChatMessage(isUser: false, text: "AI reply to: \(text)", showPinyin: false))
        }
    }
    
    func loadMore() {
        guard canLoadMore else { return }
        canLoadMore = false
        // Simulate loading more messages when user scrolls up
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let more = [
                ChatMessage(isUser: false, text: "Older message...", showPinyin: false),
                ChatMessage(isUser: true, text: "User old message", showPinyin: false)
            ]
            self.messages.insert(contentsOf: more, at: 0)
            self.canLoadMore = true
        }
    }
}
