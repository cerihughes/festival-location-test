import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKCircle else { return .init() }
        let renderer = MKCircleRenderer(circle: overlay)
        renderer.fillColor = .red
        renderer.alpha = 0.75
        return renderer
    }
}
