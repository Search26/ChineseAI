import SwiftUI

@available(iOS 16.0, *)
struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = HomeInteractor()
    
    var body: some View {
        ZStack {
            Color.homeBackground.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    HomeProfileRow()
                    HomeProgressCard(progress: 0.8)
                    Text("Daily Dose")
                        .font(.rubik(size: 17, weight: .bold))
                        .foregroundColor(.homeText)
                        .padding(.horizontal, 4)
                    HomeDailyDose()
                    Text("Quick Actions")
                        .font(.rubik(size: 17, weight: .bold))
                        .foregroundColor(.homeText)
                        .padding(.horizontal, 4)
                    HomeQuickActions()
                    Text("Review Queue")
                        .font(.rubik(size: 17, weight: .bold))
                        .foregroundColor(.homeText)
                        .padding(.horizontal, 4)
                    HomeReviewQueue(dueCount: 12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeView().environmentObject(AppState())
}
