import UIKit

class LineupTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let timeLabel = UILabel()

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        timeLabel.font = .preferredFont(forTextStyle: .title3)

        contentView.addSubviews(nameLabel, timeLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(with viewData: ViewData) {
        backgroundColor = viewData.isEven ? .cellBackground1 : .cellBackground2
        nameLabel.text = viewData.name
        nameLabel.textColor = viewData.timeStatus.titleColour
        timeLabel.text = viewData.time
        timeLabel.textColor = viewData.timeStatus.detailColour
    }
}

private extension LineupTableViewCell.TimeStatus {
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
