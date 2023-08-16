import SnapKit
import UIKit

class SettingsView: UIView {
    let reloadDataButton = UIButton.createButton(title: "Reload Data")
    let showStagesJSONButton = UIButton.createButton(title: "Show Stages JSON")
    let locationButton = UIButton.createButton(title: "Location Permissions")
    let notificationsButton = UIButton.createButton(title: "Notification Permissions")
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

private extension UIButton {
    static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .cellBackground1
        button.setTitle(title, for: .normal)
        return button
    }
}
