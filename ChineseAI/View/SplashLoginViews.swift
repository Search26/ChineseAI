import SwiftUI

@available(iOS 16.0, *)
enum AuthLaunchState: Equatable {
    case loading
    case authenticated
    case unauthenticated
    case error(String)

    static func == (lhs: AuthLaunchState, rhs: AuthLaunchState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.authenticated, .authenticated): return true
        case (.unauthenticated, .unauthenticated): return true
        case (.error(let l), .error(let r)): return l == r
        default: return false
        }
    }
}

@available(iOS 16.0, *)
struct SplashView: View {
    @StateObject private var authManager = AuthManager()
    @State private var launchState: AuthLaunchState = .loading
    @State private var lastError: String? = nil
    @State private var retryCount: Int = 0
    
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
                if launchState == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.accentColor)
                }
            }
        }
        .onAppear {
            verifyOnLaunch()
        }
        .fullScreenCover(isPresented: Binding<Bool>(
            get: { launchState != .loading },
            set: { _ in }
        )) {
            switch launchState {
            case .authenticated:
                MainTabBarView()
            case .unauthenticated:
                LoginView()
            case .error(let message):
                VStack(spacing: 16) {
                    Text("Network or verification error:")
                        .foregroundColor(.red)
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        retryCount += 1
                        verifyOnLaunch()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemBackground))
            default:
                EmptyView()
            }
        }
    }

    private func verifyOnLaunch() {
        launchState = .loading
        Task {
            let providers = ["google", "facebook", "apple"]
            var validToken: String? = nil
            var validProvider: String? = nil
            for provider in providers {
                if let token = AuthTokenStore.get(provider: provider),
                   let expiry = token.expiresAt, expiry > Date() {
                    if provider == "google", let idToken = token.idToken {
                        validToken = idToken
                        validProvider = provider
                        break
                    } else if provider != "google" {
                        validToken = token.accessToken
                        validProvider = provider
                        break
                    }
                }
            }
            if let token = validToken, let provider = validProvider {
                let result = await verifyTokenWithAPI(token: token, provider: provider)
                switch result {
                case .success(let isValid):
                    if isValid {
                        authManager.isAuthenticated = true
                        launchState = .authenticated
                    } else {
                        authManager.isAuthenticated = false
                        launchState = .unauthenticated
                    }
                case .failure(let error):
                    lastError = error.localizedDescription
                    launchState = .error(error.localizedDescription)
                }
            } else {
                authManager.isAuthenticated = false
                launchState = .unauthenticated
            }
        }
    }
}

// MARK: - API Verification Helper

@available(iOS 16.0, *)
enum TokenVerificationResult {
    case success(Bool)
    case failure(Error)
}

@available(iOS 16.0, *)
func verifyTokenWithAPI(token: String, provider: String) async -> TokenVerificationResult {
    if provider == "google" {
        // Assume token is an ID token, use Google endpoint
        guard let url = URL(string: "https://oauth2.googleapis.com/tokeninfo?id_token=\(token)") else {
            return .failure(NSError(domain: "InvalidURL", code: -1))
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .success(false)
            }
            // Optionally parse claims from `data` here
            return .success(true)
        } catch {
            print("Google ID token verification failed: \(error)")
            return .failure(error)
        }
    } else {
        // For other providers, fallback to your backend API (replace URL as needed)
        guard let url = URL(string: "https://your.api.endpoint/verify-token") else {
            return .failure(NSError(domain: "InvalidURL", code: -1))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["accessToken": token, "provider": provider]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .success(false)
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let valid = json["valid"] as? Bool {
                return .success(valid)
            }
            return .success(false)
        } catch {
            print("Token verification failed: \(error)")
            return .failure(error)
        }
    }
}




@available(iOS 16.0, *)
struct LoginView: View {
    @StateObject private var viewModel: AuthViewModel
    @StateObject private var authManager = AuthManager()
    
    init() {
        let manager = AuthManager()
        _authManager = StateObject(wrappedValue: manager)
        _viewModel = StateObject(wrappedValue: AuthViewModel(authManager: manager))
    }
    
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
