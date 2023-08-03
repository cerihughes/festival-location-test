import MapKit
import SnapKit
import UIKit

class AreasMapView: UIView {
    struct MapPosition {
        let location: Location
        let distance: Int
    }
    let mapView = MKMapView()
    private let mapDelegate = MapViewDelegate()

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

        addSubview(mapView)

        mapView.showsUserLocation = true
        mapView.delegate = mapDelegate

        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
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
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
    }
}
