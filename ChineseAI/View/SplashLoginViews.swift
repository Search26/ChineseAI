import SwiftUI

@available(iOS 16.0, *)
struct SplashView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "character.book.closed.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                Text("ChineseAI")
                    .font(.largeTitle.bold())
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.accentColor)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            LoginView()
        }
    }
}

@available(iOS 16.0, *)
struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                Text("Welcome to ChineseAI")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                VStack(spacing: 16) {
                    LoginButton(provider: .apple) {
                        signIn(.apple)
                    }
                    LoginButton(provider: .google) {
                        signIn(.google)
                    }
                    LoginButton(provider: .facebook) {
                        signIn(.facebook)
                    }
                }
                if case .loading = viewModel.authState {
                    ProgressView("Signing in...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.accentColor)
                }
                if case .error(let message) = viewModel.authState {
                    Text(message)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                // Add navigation to MainTabBarView on successful login
                NavigationLink(destination: MainTabBarView(), isActive: Binding(
                    get: { if case .success = viewModel.authState { return true } else { return false } },
                    set: { _ in }
                )) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
    
    private func signIn(_ provider: AuthProvider) {
        Task {
            await viewModel.signIn(provider: provider)
        }
    }
}

@available(iOS 16.0, *)
enum AuthProvider: String, CaseIterable, Identifiable {
    case apple, google, facebook
    var id: String { rawValue }
    var title: String {
        switch self {
        case .apple: return "Sign in with Apple"
        case .google: return "Sign in with Google"
        case .facebook: return "Sign in with Facebook"
        }
    }
    var icon: String {
        switch self {
        case .apple: return "apple.logo"
        case .google: return "g.circle"
        case .facebook: return "f.circle"
        }
    }
}

@available(iOS 16.0, *)
struct LoginButton: View {
    let provider: AuthProvider
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: provider.icon)
                Text(provider.title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
    }
    
    private var backgroundColor: Color {
        switch provider {
        case .apple: return Color.black
        case .google: return Color.white
        case .facebook: return Color.blue.opacity(0.85)
        }
    }
    private var foregroundColor: Color {
        switch provider {
        case .apple: return Color.white
        case .google: return Color.black
        case .facebook: return Color.white
        }
    }
}
