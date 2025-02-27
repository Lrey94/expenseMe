import Foundation

enum ExpenseValidationError: LocalizedError {
    case nameEmptyError
    case nameLengthTooLongError
    case amountIsZeroError
    case amountIsTooHighError
    case imageError
    case locationError
    case insertionError
    
    var failureReason: String? {
        switch self {
        case .nameEmptyError:
            return "Expense name is empty."
        case .nameLengthTooLongError:
            return "The expense name is too long"
        case .amountIsZeroError:
            return "The amount entered cannot be zero."
        case .amountIsTooHighError:
            return "The amount entered is too high."
        case .imageError:
            return "The image used is not compatible."
        case .locationError:
            return "Error extracting location data."
        case .insertionError:
            return "Error saving expense to database."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .nameEmptyError:
            return "Please provide an expense name."
        case .nameLengthTooLongError:
            return "Choose a shorter expense name"
        case .amountIsZeroError:
            return "Enter an amount higher than zero"
        case .amountIsTooHighError:
            return "Enter an amount between 0.01 and 999,999"
        case .imageError:
            return "Choose a different image or contact support"
        case .locationError:
            return "Try again later."
        case .insertionError:
            return "Contact support."
        }
    }
}
