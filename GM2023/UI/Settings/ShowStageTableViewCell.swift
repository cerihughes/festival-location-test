import UIKit

protocol ShowStageTableViewCellDelegate: AnyObject {
    func showStageTableViewCell(_ showStageTableViewCell: ShowStageTableViewCell, didToggleTo value: Bool)
}

class ShowStageTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let toggle = UISwitch()

    weak var delegate: ShowStageTableViewCellDelegate?

    struct ViewData {
        let name: String
        let selected: Bool
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

        nameLabel.font = .preferredFont(forTextStyle: .title2)
        toggle.addTarget(self, action: #selector(toggleTapped), for: .valueChanged)

        contentView.addSubviews(nameLabel, toggle)

        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }

        toggle.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with viewData: ViewData) {
        nameLabel.text = viewData.name
        toggle.isOn = viewData.selected
    }

    @objc private func toggleTapped(_ toggle: UISwitch) {
        delegate?.showStageTableViewCell(self, didToggleTo: toggle.isOn)
    }
}
