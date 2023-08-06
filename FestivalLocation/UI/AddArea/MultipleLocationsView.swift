import SnapKit
import UIKit

class MultipleLocationsView: UIView {
    let addCurrentPosition = UIButton(type: .system)

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

        addCurrentPosition.setTitle("Add Current Location", for: .normal)

        addSubview(addCurrentPosition)

        addCurrentPosition.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
    }
}
