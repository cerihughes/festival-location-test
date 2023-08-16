import UIKit

class HistoryTableViewCell: UITableViewCell {
    let nameLabel = UILabel()

    struct ViewData {
        let isEven: Bool
        let title: String
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

        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with viewData: ViewData) {
        backgroundColor = viewData.isEven ? .cellBackground1 : .cellBackground2
        nameLabel.text = viewData.title
    }
}
