import CoreLocation

class DefaultLocationManager: NSObject, LocationManager {
    private let locationManager = CLLocationManager()
    private var monitoredRegions = [String: CLRegion]()

    private var getLocationContinuation: CheckedContinuation<Location, Never>?

    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    var authorisationStatus: AuthorisationStatus {
        locationManager.authorizationStatus.asAuthorisationStatus()
    }

    func authorise() {
        locationManager.requestWhenInUseAuthorization()
    }

    func getLocation() async -> Location? {
        guard CLLocationManager.locationServicesEnabled() else { return nil }
        return await withCheckedContinuation { continuation in
            getLocationContinuation = continuation
            locationManager.startUpdatingLocation()
        }
    }

    func startMonitoring(location: Location, radius: Double, name: String) -> Bool {
        guard monitoredRegions[name] == nil else { return false }
        let region = CLCircularRegion(center: location.asCoordinate(), radius: radius, identifier: name)
        region.notifyOnEntry = true
        region.notifyOnExit = true

        monitoredRegions[name] = region
        locationManager.startMonitoring(for: region)
        return true
    }

    func stopMonitoring(name: String) -> Bool {
        guard let region = monitoredRegions.removeValue(forKey: name) else { return false }
        locationManager.stopMonitoring(for: region)
        return true
    }
}

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        getLocationContinuation?.resume(returning: location.coordinate.asLocation())
        getLocationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion, monitoredRegions[region.identifier] != nil else { return }
        delegate?.locationManager(self, didEnter: region.center.asLocation(), name: region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion, monitoredRegions[region.identifier] != nil else { return }
        delegate?.locationManager(self, didExit: region.center.asLocation(), name: region.identifier)
    }
}

private extension CLAuthorizationStatus {
    func asAuthorisationStatus() -> AuthorisationStatus {
        switch self {
        case .notDetermined:
            return .notAsked
        case .authorizedAlways:
            return .accepted
        case .authorizedWhenInUse:
            return .partial
        case .restricted, .denied:
            return .refused
        @unknown default:
            return .refused
        }
    }
}
