// AuthToken.swift
// Handles secure storage of login tokens for Google, Facebook, Apple using Realm
// iOS 16+, Swift 5.7+

import Foundation
import RealmSwift

// MARK: - Realm Model for Auth Token
final class AuthToken: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var provider: String // "google", "facebook", "apple"
    @Persisted var accessToken: String
    @Persisted var idToken: String?
    @Persisted var refreshToken: String?
    @Persisted var expiresAt: Date?
    
    // Convenience initializer
    convenience init(provider: String, accessToken: String, idToken: String? = nil, refreshToken: String? = nil, expiresAt: Date? = nil) {
        self.init()
        self.provider = provider
        self.accessToken = accessToken
        self.idToken = idToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}

// MARK: - AuthToken Storage Utility
struct AuthTokenStore {
    // Save or update a token
    static func save(provider: String, accessToken: String, idToken: String? = nil, refreshToken: String? = nil, expiresAt: Date? = nil) throws {
        let realm = try Realm()
        let token = AuthToken(provider: provider, accessToken: accessToken, idToken: idToken, refreshToken: refreshToken, expiresAt: expiresAt)
        try realm.write {
            realm.add(token, update: .modified)
        }
    }
    
    // Retrieve a token for a provider
    static func get(provider: String) -> AuthToken? {
        guard let realm = try? Realm() else { return nil }
        return realm.object(ofType: AuthToken.self, forPrimaryKey: provider)
    }
    
    // Delete a token for a provider
    static func delete(provider: String) throws {
        let realm = try Realm()
        if let token = realm.object(ofType: AuthToken.self, forPrimaryKey: provider) {
            try realm.write {
                realm.delete(token)
            }
        }
    }
    
    // Check if a valid (non-expired) token exists
    static func isValid(provider: String) -> Bool {
        guard let token = get(provider: provider) else { return false }
        if let expiry = token.expiresAt {
            return expiry > Date()
        }
        return true // If no expiry, treat as valid
    }
}

// MARK: - Google Token Convenience

extension AuthTokenStore {
    /// Save Google login token after successful authentication
    static func saveGoogleToken(accessToken: String, idToken: String? = nil, refreshToken: String? = nil, expiresAt: Date? = nil) {
        try? save(provider: "google", accessToken: accessToken, idToken: idToken, refreshToken: refreshToken, expiresAt: expiresAt)
    }

    /// Retrieve a valid Google ID token for silent login on app launch
    /// - Returns: idToken if present and not expired, else nil
    static func validGoogleIDToken() -> String? {
        guard let token = get(provider: "google"),
              let expiry = token.expiresAt, expiry > Date(),
              let idToken = token.idToken else {
            return nil
        }
        return idToken
    }
}

// MARK: - Usage Example
// After Google login:
// AuthTokenStore.saveGoogleToken(accessToken: googleToken, refreshToken: googleRefresh, expiresAt: expiryDate)
//
// On app launch:
// if let accessToken = AuthTokenStore.validGoogleAccessToken() {
//     // Use accessToken for silent login
// }
//
// You can use similar helpers for Facebook/Apple by adding similar extensions.

// MARK: - Facebook Token Convenience
extension AuthTokenStore {
    /// Save Facebook login token after successful authentication
    static func saveFacebookToken(accessToken: String, idToken: String? = nil, refreshToken: String? = nil, expiresAt: Date? = nil) {
        try? save(provider: "facebook", accessToken: accessToken, idToken: idToken, refreshToken: refreshToken, expiresAt: expiresAt)
    }

    /// Retrieve a valid Facebook token for silent login on app launch
    /// - Returns: accessToken if present and not expired, else nil
    static func validFacebookAccessToken() -> String? {
        guard let token = get(provider: "facebook"),
              let expiry = token.expiresAt, expiry > Date() else {
            return nil
        }
        return token.accessToken
    }
}

// MARK: - Apple Token Convenience
extension AuthTokenStore {
    /// Save Apple login token after successful authentication
    static func saveAppleToken(accessToken: String, refreshToken: String? = nil, expiresAt: Date? = nil) {
        try? save(provider: "apple", accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiresAt)
    }

    /// Retrieve a valid Apple token for silent login on app launch
    /// - Returns: accessToken if present and not expired, else nil
    static func validAppleAccessToken() -> String? {
        guard let token = get(provider: "apple"),
              let expiry = token.expiresAt, expiry > Date() else {
            return nil
        }
        return token.accessToken;
    }
}

