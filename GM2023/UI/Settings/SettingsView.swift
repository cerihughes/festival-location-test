import SnapKit
import UIKit

class SettingsView: UIView {
    let reloadStagesButton = UIButton(type: .roundedRect)

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

        addSubview(reloadStagesButton)

        reloadStagesButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
