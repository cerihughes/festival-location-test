import SnapKit
import UIKit

class SettingsView: UIView {
    let reloadDataButton = UIButton.settingsButton(title: "Reload Data")
    let showStagesJSONButton = UIButton.settingsButton(title: "Show Stages JSON")
    let locationButton = UIButton.settingsButton(title: "Location Permissions")
    let notificationsButton = UIButton.settingsButton(title: "Notification Permissions")
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

        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "Stages to show:"
        stageTableView.separatorStyle = .none
        stageTableView.allowsSelection = false

        addSubviews(reloadDataButton, showStagesJSONButton, locationButton, notificationsButton, label, stageTableView)

        reloadDataButton.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }

        showStagesJSONButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(reloadDataButton.snp.trailing).offset(16)
            make.width.equalTo(reloadDataButton)
        }

        locationButton.snp.makeConstraints { make in
            make.top.equalTo(reloadDataButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(reloadDataButton)
        }

        notificationsButton.snp.makeConstraints { make in
            make.top.equalTo(locationButton)
            make.leading.trailing.equalTo(showStagesJSONButton)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }

        stageTableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
