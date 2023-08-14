import Foundation

@testable import FestivalLocation

class MockLocationMonitor: LocationMonitor {
    var currentLocation: String?
    var lastEnteredLocation: String?

    func start() {}
    func stop() {}
}
