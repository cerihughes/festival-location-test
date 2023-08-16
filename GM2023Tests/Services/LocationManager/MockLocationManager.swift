import Foundation

@testable import GM2023

class MockLocationManager: LocationManager {
    var delegate: LocationManagerDelegate?
    var authorisationDelegate: LocationManagerAuthorisationDelegate?
    var lastAuthorisationStatus: LocationAuthorisation?

    var requestWhenInUseAuthorisationResult = false
    func requestWhenInUseAuthorisation() {
        let authorisation: LocationAuthorisation = requestWhenInUseAuthorisationResult ? .whenInUse : .denied
        lastAuthorisationStatus = authorisation
        authorisationDelegate?.locationManager(self, didChangeAuthorisation: authorisation)
    }

    var requestAlwaysAuthorisationResult = false
    func requestAlwaysAuthorisation() {
        let authorisation: LocationAuthorisation = requestWhenInUseAuthorisationResult ? .always : .denied
        lastAuthorisationStatus = authorisation
        authorisationDelegate?.locationManager(self, didChangeAuthorisation: authorisation)
    }

    var getLocationResult: Location?
    func getLocation() async -> Location? {
        getLocationResult
    }

    var startMonitoringResult = false
    func startMonitoring(location: Location, radius: Double, name: String) -> Bool {
        startMonitoringResult
    }

    var stopMonitoringResult = false
    func stopMonitoring(name: String) -> Bool {
        stopMonitoringResult
    }
}
