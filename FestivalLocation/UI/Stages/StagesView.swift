import MapKit
import SnapKit
import UIKit

class StagesView: UIView {
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

        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = true
        mapView.delegate = mapDelegate

        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func removeAllAndRender(mapCircles: [MKCircle]) {
        removeAll()
        render(mapCircles: mapCircles)
    }

    private func render(mapCircles: [MKCircle]) {
        mapView.addOverlays(mapCircles)
        mapView.showAnnotations(mapCircles, animated: true)
    }

    private func removeAll() {
        mapView.overlays.forEach {
            mapView.removeOverlay($0)
        }
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
    }
}
