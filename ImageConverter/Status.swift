enum Status: Equatable { // Add Equatable for easier comparison
    case idle
    case processing
    case failure(message: String) // The 'failure' case now carries a String payload
    
    // We need to implement Equatable manually now that we have an associated value
    static func == (lhs: Status, rhs: Status) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.processing, .processing):
            return true
        case let (.failure(lhsMessage), .failure(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
