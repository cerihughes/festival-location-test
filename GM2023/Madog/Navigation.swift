import Foundation

enum Navigation: Equatable {
    case authorisation
    case lineup
    case stages
    case addStage
    case histories
    case history(String)
    case reloadData
}
