import SnapKit
import UIKit

class SettingsView: UIView {
    let reloadDataButton = UIButton(type: .roundedRect)
    let showStagesJSONButton = UIButton(type: .roundedRect)
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

        reloadDataButton.backgroundColor = .cellBackground1
        reloadDataButton.setTitle("Reload Data", for: .normal)
        showStagesJSONButton.backgroundColor = .cellBackground1
        showStagesJSONButton.setTitle("Show Stages JSON", for: .normal)

        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "Stages to show:"
        stageTableView.separatorStyle = .none
        stageTableView.allowsSelection = false

        addSubviews(reloadDataButton, showStagesJSONButton, label, stageTableView)

        reloadDataButton.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }

        showStagesJSONButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(reloadDataButton.snp.trailing).offset(16)
            make.width.equalTo(reloadDataButton)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(reloadDataButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }

        stageTableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
