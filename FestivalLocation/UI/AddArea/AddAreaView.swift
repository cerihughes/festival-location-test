import MapKit
import SnapKit
import UIKit

protocol AddAreaViewDelegate: AnyObject {
    func areasMapView(_ areasMapView: AddAreaView, didSelect location: Location)
}

class AddAreaView: UIView {
    struct MapPosition {
        let location: Location
        let distance: Int
    }
    let mapView = MKMapView()
    private let mapDelegate = MapViewDelegate()
    private let floatingContainer = UIView()
    let nameField = UITextField()
    let useCurrentButton = UIButton(type: .system)
    private lazy var tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(mapTapped))

    weak var delegate: AddAreaViewDelegate?

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
        floatingContainer.backgroundColor = .white

        nameField.placeholder = "Enter Area Name"
        useCurrentButton.setTitle("Use Current Location", for: .normal)

        let containerLayoutGuide = UILayoutGuide()
        floatingContainer.addLayoutGuide(containerLayoutGuide)

        floatingContainer.addSubviews(nameField, useCurrentButton)
        addSubviews(mapView, floatingContainer)

        containerLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(16)
        }

        nameField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(containerLayoutGuide)
        }

        useCurrentButton.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerLayoutGuide)
        }

        floatingContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.width.equalTo(readableContentGuide)
        }

        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }

        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(tapGestureRecogniser)
        mapView.delegate = mapDelegate
    }

    func render(location: Location) {
        removeAllLocations()
        let overlay = MKCircle(center: location.asCoordinate(), radius: 50)
        mapView.addOverlay(overlay)
        mapView.showAnnotations([overlay], animated: true)
    }

    func removeAllLocations() {
        mapView.overlays.forEach {
            mapView.removeOverlay($0)
        }
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
    }

    @objc private func mapTapped(_ gestureRecogniser: UITapGestureRecognizer) {
        guard gestureRecogniser.state == .ended else { return }

        let point = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        delegate?.areasMapView(self, didSelect: coordinate.asLocation())
    }
}
