import SnapKit
import UIKit

class ExportStagesView: UIView {
    let deleteButton = UIButton.settingsButton(title: "Delete Stages")
    let textView = UITextView()

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

        addSubviews(deleteButton, textView)

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
