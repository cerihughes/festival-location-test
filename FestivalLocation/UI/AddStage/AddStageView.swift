import MapKit
import SnapKit
import UIKit

protocol AddStageViewDelegate: AnyObject {
    func addStageView(_ addStageView: AddStageView, didSelect location: Location)
}

class AddStageView: UIView {
    enum Mode {
        case single, multiple
    }

    let mapView = MKMapView()
    private let mapDelegate = MapViewDelegate()
    private let floatingContainer = UIView()
    let nameField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["Use Single Location", "Use Multiple Locations"])
    let radiusSliderView = RadiusSliderView()
    let useGPSButton = UIButton(type: .system)

    private lazy var tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(mapTapped))

    weak var delegate: AddStageViewDelegate?

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
        floatingContainer.layer.cornerRadius = 10
        floatingContainer.backgroundColor = .white
        floatingContainer.alpha = 0.9

        nameField.placeholder = "Enter Stage Name"
        useGPSButton.setTitle("Use GPS Location", for: .normal)

        segmentedControl.selectedSegmentIndex = 0

        let containerLayoutGuide = UILayoutGuide()
        floatingContainer.addLayoutGuide(containerLayoutGuide)

        floatingContainer.addSubviews(nameField, segmentedControl, radiusSliderView, useGPSButton)
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

        radiusSliderView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalTo(containerLayoutGuide)
        }

        useGPSButton.snp.makeConstraints { make in
            make.top.equalTo(radiusSliderView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerLayoutGuide).inset(16)
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

    var mode: Mode {
        segmentedControl.selectedSegmentIndex == 0 ? .single : .multiple
    }

    var overlay: MKCircle? {
        didSet {
            if let oldValue {
                mapView.removeOverlay(oldValue)
            }
            if let overlay {
                mapView.addOverlay(overlay)
                mapView.setVisibleMapRect(overlay.mapRect(
                    delta: 50,
                    yOffset: -1000
                ), animated: true)
            }
        }
    }

    var annotations = [MKAnnotation]() {
        didSet {
            mapView.removeAnnotations(oldValue)
            mapView.addAnnotations(annotations)
        }
    }

    @objc private func mapTapped(_ gestureRecogniser: UITapGestureRecognizer) {
        guard gestureRecogniser.state == .ended else { return }

        let point = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        delegate?.addStageView(self, didSelect: coordinate.asLocation())
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
