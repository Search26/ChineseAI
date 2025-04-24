import Foundation
import Combine

@available(iOS 16.0, *)
final class HomeInteractor: ObservableObject {
    @Published var items: [HomeCardItem] = [
        HomeCardItem(title: "Daily Practice", subtitle: "Keep your streak alive!"),
        HomeCardItem(title: "New Words", subtitle: "Learn 10 new words today"),
        HomeCardItem(title: "Grammar Tips", subtitle: "Master a new grammar point")
    ]
}

struct HomeCardItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
