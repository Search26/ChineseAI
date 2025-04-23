import Foundation

enum AuthError: Error, LocalizedError {
    case missingGoogleClientID
    case noRootViewController
    case cancelled
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingGoogleClientID: return "Missing Google Client ID."
        case .noRootViewController: return "No root view controller available."
        case .cancelled: return "Authentication was cancelled."
        case .unknown: return "Unknown authentication error."
        }
    }
}
