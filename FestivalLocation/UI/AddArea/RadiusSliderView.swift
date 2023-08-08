import SnapKit
import UIKit

class RadiusSliderView: UIView {
    let radiusSlider = UISlider()
    let radiusLabel = UILabel()

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

        radiusLabel.textAlignment = .center
        radiusSlider.minimumValue = 50.0
        radiusSlider.maximumValue = 500.0

        addSubviews(radiusSlider, radiusLabel)

        radiusSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalTo(radiusLabel)
        }

        radiusLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(radiusSlider.snp.trailing).offset(16)
        }
    }
}
