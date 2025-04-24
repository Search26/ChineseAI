import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let isUser: Bool
    let text: String
    let showPinyin: Bool
    let pinyin: String?
    let grammar: GrammarAnalysis?
    let pronunciation: (chinese: String, score: Int)?
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.isUser == rhs.isUser &&
               lhs.text == rhs.text &&
               lhs.showPinyin == rhs.showPinyin &&
               lhs.pinyin == rhs.pinyin &&
               lhs.grammar?.id == rhs.grammar?.id &&
               lhs.pronunciation?.chinese == rhs.pronunciation?.chinese &&
               lhs.pronunciation?.score == rhs.pronunciation?.score
    }
    
    init(id: UUID = UUID(), isUser: Bool, text: String, showPinyin: Bool = false, pinyin: String? = nil, grammar: GrammarAnalysis? = nil, pronunciation: (chinese: String, score: Int)? = nil) {
        self.id = id
        self.isUser = isUser
        self.text = text
        self.showPinyin = showPinyin
        self.pinyin = pinyin
        self.grammar = grammar
        self.pronunciation = pronunciation
    }
}

@available(iOS 16.0, *)
struct LearnView: View {
    @StateObject private var viewModel = LearnViewModel()
    @State private var inputText: String = ""
    @State private var showPinyinFor: UUID? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            TutorHeaderView(mode: $viewModel.tutorMode)
            Divider()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            VStack(spacing: 4) {
                                ChatBubble(message: message, showPinyin: showPinyinFor == message.id) {
                                    withAnimation { showPinyinFor = (showPinyinFor == message.id) ? nil : message.id }
                                }
                                if let pronunciation = message.pronunciation {
                                    PronunciationWidget(chinese: pronunciation.chinese, score: pronunciation.score)
                                }
                                if let grammar = message.grammar {
                                    GrammarWidget(analysis: grammar)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            ChatInputView(text: $inputText, onSend: {
                viewModel.sendMessage(text: inputText)
                inputText = ""
            })
        }
        .background(Color(.systemGroupedBackground))
        .hideKeyboardOnTap()
    }
}

@available(iOS 16.0, *)
struct ChatBubble: View {
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

@available(iOS 16.0, *)
struct TutorHeaderView: View {
    @Binding var mode: TutorMode
    var body: some View {
        HStack {
            Text("Chinese Tutor")
                .font(.rubik(size: 17, weight: .bold))
            Spacer()
            ForEach(TutorMode.allCases, id: \ .self) { m in
                Button(action: { mode = m }) {
                    Text(m.rawValue)
                        .font(.rubik(size: 13, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(mode == m ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(6)
                }
                .foregroundColor(mode == m ? .blue : .gray)
            }
        }
        .padding([.horizontal, .top], 12)
    }
}

enum TutorMode: String, CaseIterable {
    case zh = "中文"
    case mix = "Mix"
    case en = "EN"
}
