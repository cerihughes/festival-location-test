import UIKit

class FestivalSlotTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum TimeStatus {
        case past, pending, current, future
    }

    struct ViewData {
        let name: String
        let time: String
        let timeStatus: TimeStatus
        let visited: Bool
    }
}

extension FestivalSlotTableViewCell.TimeStatus {
    var colour: UIColor {
        switch self {
        case .past:
            return .gray
        case .pending:
            return .orange
        case .current:
            return .green
        case .future:
            return .black
        }
    }
}
