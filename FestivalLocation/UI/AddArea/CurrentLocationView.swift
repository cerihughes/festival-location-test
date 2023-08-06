import SnapKit
import UIKit

class CurrentLocationView: UIView {
    let useCurrentButton = UIButton(type: .system)

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

        useCurrentButton.setTitle("Use Current Location", for: .normal)

        addSubview(useCurrentButton)

        useCurrentButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
    }
}
