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
        addSubview(mapView)

        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(tapGestureRecogniser)
        mapView.delegate = self

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

    func removeAllAndRender(areas: [Area]) {
        removeAllAreas()
        render(areas: areas)
    }

    func render(areas: [Area]) {
        let overlays = areas.map { MKCircle(center: $0.location.asCoordinate(), radius: 50) }
        mapView.addOverlays(overlays)
        mapView.showAnnotations(overlays, animated: true)
    }

    func removeAllAreas() {
        mapView.overlays.forEach {
            mapView.removeOverlay($0)
        }
    }

    @objc private func mapTapped(_ gestureRecogniser: UITapGestureRecognizer) {
        guard gestureRecogniser.state == .ended else { return }

        let point = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        delegate?.areasMapView(self, didSelect: coordinate.asLocation())
    }
}

extension AddAreaView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKCircle else { return .init() }
        let renderer = MKCircleRenderer(circle: overlay)
        renderer.fillColor = .red
        renderer.alpha = 0.75
        return renderer
    }
}
