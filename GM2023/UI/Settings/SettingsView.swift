import SnapKit
import UIKit

class SettingsView: UIView {
    let reloadStagesButton = UIButton(type: .roundedRect)
    let label = UILabel()
    let stageTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        reloadStagesButton.setTitle("Reload Stage Data", for: .normal)
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "Stages to show:"
        stageTableView.separatorStyle = .none
        stageTableView.allowsSelection = false

        addSubviews(reloadStagesButton, label, stageTableView)

        reloadStagesButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(reloadStagesButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }

        stageTableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
