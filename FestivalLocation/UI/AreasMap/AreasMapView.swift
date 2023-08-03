import MapKit
import SnapKit
import UIKit

class AreasMapView: UIView {
    struct MapPosition {
        let location: Location
        let distance: Int
    }
    let mapView = MKMapView()

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
        mapView.delegate = self

        mapView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
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
}

extension AreasMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKCircle else { return .init() }
        let renderer = MKCircleRenderer(circle: overlay)
        renderer.fillColor = .red
        renderer.alpha = 0.75
        return renderer
    }
}
