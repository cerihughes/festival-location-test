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
    let segmentedControl = UISegmentedControl(items: ["Use GPS", "Use Map", "Use Multiple Points"])
    private let segmentContainer = UIView()
    let currentLocationView = CurrentLocationView()
    let locationAndRadiusView = LocationAndRadiusView()
    let multipleLocationsView = MultipleLocationsView()

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

        segmentedControl.selectedSegmentIndex = 0
        showSegment(index: 0)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        let containerLayoutGuide = UILayoutGuide()
        floatingContainer.addLayoutGuide(containerLayoutGuide)

        floatingContainer.addSubviews(nameField, segmentedControl, segmentContainer)
        segmentContainer.addSubviews(currentLocationView, locationAndRadiusView, multipleLocationsView)
        addSubviews(mapView, floatingContainer)

        containerLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(16)
        }

        nameField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(containerLayoutGuide)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(containerLayoutGuide)
        }

        segmentContainer.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalTo(containerLayoutGuide)
            make.bottom.equalTo(containerLayoutGuide).inset(16)
        }

        currentLocationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        locationAndRadiusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        multipleLocationsView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
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

    @objc private func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
        showSegment(index: segmentedControl.selectedSegmentIndex)
    }

    private func showSegment(index: Int) {
        let views = [currentLocationView, locationAndRadiusView, multipleLocationsView]
        for (viewIndex, view) in views.enumerated() {
            view.isHidden = viewIndex != index
        }
    }

    var overlay: MKCircle? {
        didSet {
            removeAllLocations()
            if let overlay {
                mapView.addOverlay(overlay)
                mapView.addAnnotation(overlay)
                mapView.setVisibleMapRect(overlay.mapRect(
                    delta: 50,
                    yOffset: -1000
                ), animated: true)
            }
        }
    }

    private func removeAllLocations() {
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

private extension MKCircle {
    private func adjustedRadius(by delta: Double) -> MKCircle {
        .init(center: coordinate, radius: radius + delta)
    }

    func mapRect(delta: Double, yOffset: Double) -> MKMapRect {
        adjustedRadius(by: delta)
            .boundingMapRect
            .offsetBy(dx: 0, dy: radius * -6) // -6 is the "best so far" - see below

        // TODO: Calculate this by probably converting the Map Rect into a rect of the same
        // aspect ratio of the map view, and making sure the original map rect is centered
        // in the space between the map view bottom and the container overlay bottom.
    }
}
