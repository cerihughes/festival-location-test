import SnapKit
import UIKit

class AreasExportView: UIView {
    let importButton = UIButton(type: .roundedRect)
    let exportButton = UIButton(type: .roundedRect)
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

        importButton.setTitle("Import Areas", for: .normal)
        exportButton.setTitle("Export Areas", for: .normal)
        textView.isUserInteractionEnabled = false

        addSubviews(importButton, exportButton, textView)

        importButton.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).dividedBy(2)
        }

        exportButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).dividedBy(2)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(importButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
