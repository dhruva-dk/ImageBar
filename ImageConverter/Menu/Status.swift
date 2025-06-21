import SwiftUI

enum Status: Equatable {
    case idle
    case processing
    case failure(message: String)
    // Add the new success case
    case success(message: String, outputURL: URL)
    
    // We need to implement Equatable manually now that we have an associated value
    static func == (lhs: Status, rhs: Status) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.processing, .processing):
            return true
        case let (.failure(lhsMessage), .failure(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.success(lhsMessage, lhsURL), .success(rhsMessage, rhsURL)):
            return lhsMessage == rhsMessage && lhsURL == rhsURL
        default:
            return false
        }
    }
}
