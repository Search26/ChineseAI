import SwiftUI

enum QuickActionType: CaseIterable, Identifiable {
    case chatTutor, practice, grammar, imageToVocab
    var id: Self { self }
}

struct QuickActionCard: Identifiable {
    let id = UUID()
    let type: QuickActionType
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let bgColor: Color
}

@available(iOS 16.0, *)
struct HomeQuickActions: View {
    @State private var selectedAction: QuickActionType? = nil
    let actions: [QuickActionCard] = [
        QuickActionCard(type: .chatTutor, icon: "bubble.left.and.bubble.right.fill", iconColor: .white, title: "Chat Tutor", subtitle: "Practice conversation", bgColor: Color(hex: "3B82F6")),
        QuickActionCard(type: .practice, icon: "mic.fill", iconColor: .white, title: "Practice", subtitle: "Pronunciation", bgColor: Color(hex: "8B5CF6")),
        QuickActionCard(type: .grammar, icon: "text.book.closed.fill", iconColor: .white, title: "Grammar", subtitle: "Get help", bgColor: Color(hex: "22C55E")),
        QuickActionCard(type: .imageToVocab, icon: "camera.fill", iconColor: .white, title: "Image → Vocab", subtitle: "Learn from photos", bgColor: Color(hex: "F97316"))
    ]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(actions) { action in
                Button(action: {
                    selectedAction = action.type
                }) {
                    VStack(alignment: .leading, spacing: 6) {
                        Image(systemName: action.icon)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(action.iconColor)
                            .padding(8)
                            .background(action.bgColor.opacity(0.9))
                            .clipShape(Circle())
                        Text(action.title)
                            .font(.rubik(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        Text(action.subtitle)
                            .font(.rubik(size: 12))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                    .padding(14)
                    .background(action.bgColor)
                    .cornerRadius(14)
                    .shadow(color: action.bgColor.opacity(0.10), radius: 2, x: 0, y: 1)
                }
                .background(
                    NavigationLink(
                        destination: destinationView(for: action.type),
                        tag: action.type,
                        selection: $selectedAction
                    ) { EmptyView() }
                    .opacity(0)
                )
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for type: QuickActionType) -> some View {
        switch type {
        case .chatTutor:
            LearnView()
        default:
            EmptyView()
        }
    }
}
