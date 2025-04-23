import Foundation
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit

@MainActor
@available(iOS 16.0, *)
final class AuthViewModel: ObservableObject {
    enum AuthState {
        case idle
        case loading
        case success
        case error(String)
    }
    
    @Published var authState: AuthState = .idle
    
    init() {}
    
    func signIn(provider: AuthProvider) async {
        authState = .loading
        do {
            switch provider {
            case .apple:
                try await signInWithApple()
            case .google:
                try await signInWithGoogle()
            case .facebook:
                try await signInWithFacebook()
            }
            authState = .success
        } catch {
            authState = .error(error.localizedDescription)
        }
    }
    
    private func signInWithApple() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            let delegate = AppleSignInDelegate { result in
                switch result {
                case .success(_):
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        }
    }
    
    private func signInWithGoogle() async throws {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
            throw AuthError.missingGoogleClientID
        }
        guard let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first?.rootViewController else {
            throw AuthError.noRootViewController
        }
        let config = GIDConfiguration(clientID: clientID)
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = result.user
        let accessToken = user.accessToken.tokenString
        let refreshToken = user.refreshToken.tokenString
        let expiresIn = user.accessToken.expirationDate
        let email = user.profile?.email
        let name = user.profile?.name
        let id = user.userID
        print("Google user: id=\(id ?? "") name=\(name ?? "") email=\(email ?? "") accessToken=\(accessToken) refreshToken=\(refreshToken) expiresIn=\(expiresIn)")
    }

    private func signInWithFacebook() async throws {
        guard let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first?.rootViewController else {
            throw AuthError.noRootViewController
        }
        let manager = LoginManager()
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            manager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result, !result.isCancelled {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: AuthError.cancelled)
                }
            }
        }
    }
}
