import CoreLocation

enum LocationAuthorisation {
    case initial, whenInUse, always, denied
}

protocol LocationManagerAuthenticationDelegate: AnyObject {
    func locationManager(
        _ locationManager: LocationManager,
        didChangeAuthorisation authorisation: LocationAuthorisation
    )
}

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ locationManager: LocationManager, didEnter location: Location, name: String)
    func locationManager(_ locationManager: LocationManager, didExit location: Location, name: String)
}

protocol LocationManager {
    var delegate: LocationManagerDelegate? { get nonmutating set }
    var authenticationDelegate: LocationManagerAuthenticationDelegate? { get nonmutating set }

    func requestWhenInUseAuthorisation()
    func requestAlwaysAuthorisation()

    func getLocation() async -> Location?
    @discardableResult
    func startMonitoring(location: Location, radius: Double, name: String) -> Bool
    @discardableResult
    func stopMonitoring(name: String) -> Bool
}
