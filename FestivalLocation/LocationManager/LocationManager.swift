import CoreLocation

struct Location {
    let lat: Double
    let lon: Double
}

enum AuthorisationStatus {
    case notAsked
    case partial
    case accepted
    case refused
}

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ locationManager: LocationManager, didEnter location: Location, name: String)
    func locationManager(_ locationManager: LocationManager, didExit location: Location, name: String)
}

protocol LocationManager {
    var delegate: LocationManagerDelegate? { get set }
    var authorisationStatus: AuthorisationStatus { get }

    func authorise()

    func getLocation() async -> Location?
    @discardableResult
    func startMonitoring(location: Location, radius: Double, name: String) -> Bool
    @discardableResult
    func stopMonitoring(name: String) -> Bool
}
