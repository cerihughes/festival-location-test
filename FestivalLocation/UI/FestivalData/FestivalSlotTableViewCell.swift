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
        let isEven: Bool
        let name: String
        let time: String
        let timeStatus: TimeStatus
        let visited: Bool
    }

    func configure(with viewData: ViewData) {
        backgroundColor = viewData.isEven ? .bg1 : .bg2
        textLabel?.text = viewData.name
        textLabel?.textColor = viewData.timeStatus.titleColour
        textLabel?.font = .preferredFont(forTextStyle: .title2)
        detailTextLabel?.text = viewData.time
        detailTextLabel?.textColor = viewData.timeStatus.detailColour
        detailTextLabel?.font = .preferredFont(forTextStyle: .title3)
    }
}

private extension FestivalSlotTableViewCell.TimeStatus {
    var titleColour: UIColor {
        switch self {
        case .past:
            return .lightGray
        case .pending:
            return .orange
        case .current:
            return .systemGreen
        case .future:
            return .black
        }
    }

    var detailColour: UIColor {
        switch self {
        case .past:
            return .lightGray
        case .pending, .current, .future:
            return .black
        }
    }
}

private extension UIColor {
    static let bg1 = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    static let bg2 = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
}
