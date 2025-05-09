// AuthManager.swift
// Handles auto-login at app launch using Realm-stored tokens for Google, Facebook, Apple
// iOS 16+, Swift 5.7+, SwiftUI

import Foundation
import Combine
import RealmSwift
import RealmSwift

final class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentProvider: String? = nil
    @Published var accessToken: String? = nil
    
    // Add more providers as needed
    private let supportedProviders = ["google", "facebook", "apple"]

    init() {
        // Configure Realm migration
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Add idToken property to existing AuthToken objects
                    migration.enumerateObjects(ofType: AuthToken.className()) { oldObject, newObject in
                        if newObject != nil {
                            newObject!["idToken"] = nil
                        }
                    }
                }
            }
        )
        
        // Set the configuration
        Realm.Configuration.defaultConfiguration = config
        
        autoLoginIfPossible()
    }

    /// Checks all supported providers for a valid access token and sets authentication state.
    func autoLoginIfPossible() {
        for provider in supportedProviders {
            if let token = AuthTokenStore.get(provider: provider),
               let expiry = token.expiresAt, expiry > Date() {
                // Token is valid
                isAuthenticated = true
                currentProvider = provider
                accessToken = token.accessToken
                return
            }
        }
        // No valid token found
        isAuthenticated = false
        currentProvider = nil
        accessToken = nil
    }

    /// Call this after a successful login to save token and update state
    func login(provider: String, accessToken: String, idToken: String? = nil, refreshToken: String? = nil, expiresAt: Date? = nil) {
        do {
            try AuthTokenStore.save(provider: provider, accessToken: accessToken, idToken: idToken, refreshToken: refreshToken, expiresAt: expiresAt)
            isAuthenticated = true
            currentProvider = provider
            self.accessToken = accessToken
        } catch {
            print("[AuthManager] Failed to save token: \(error)")
            isAuthenticated = false
        }
    }

    /// Logout and remove token for the current provider
    func logout() {
        if let provider = currentProvider {
            do {
                try AuthTokenStore.delete(provider: provider)
            } catch {
                print("[AuthManager] Failed to delete token: \(error)")
            }
        }
        isAuthenticated = false
        currentProvider = nil
        accessToken = nil
    }
}

// Usage in SwiftUI App:
// @StateObject private var authManager = AuthManager()
// if authManager.isAuthenticated { MainTabBarView() } else { LoginView() }
