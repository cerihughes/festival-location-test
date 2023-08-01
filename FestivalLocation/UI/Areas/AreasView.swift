import MapKit
import SnapKit
import UIKit

protocol AreasViewDelegate: AnyObject {
    func areasView(_ areasView: AreasView, didSelect location: Location)
}

class AreasView: UIView {
    let mapView = MKMapView()
    private lazy var tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(mapTapped))

    weak var delegate: AreasViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(mapView)

        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(tapGestureRecogniser)

        mapView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    var isMapTappable: Bool {
        get {
            tapGestureRecogniser.isEnabled
        }
        set {
            tapGestureRecogniser.isEnabled = newValue
        }
    }

    @objc private func mapTapped(_ gestureRecogniser: UITapGestureRecognizer) {
        guard gestureRecogniser.state == .ended else { return }

        let point = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        delegate?.areasView(self, didSelect: coordinate.asLocation())
    }
}
