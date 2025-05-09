import SwiftUI

@available(iOS 16.0, *)
struct MainTabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "waveform")
                }
            ReviewView()
                .tabItem {
                    Label("Review", systemImage: "checkmark.circle")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabBarView()
}
