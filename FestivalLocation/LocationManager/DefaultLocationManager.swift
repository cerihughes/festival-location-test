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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        getLocationContinuation?.resume(returning: location.coordinate.asLocation())
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

private extension Location {
    func asCoordinate() -> CLLocationCoordinate2D {
        .init(latitude: lat, longitude: lon)
    }
}

private extension CLLocationCoordinate2D {
    func asLocation() -> Location {
        .init(lat: latitude, lon: longitude)
    }
}
