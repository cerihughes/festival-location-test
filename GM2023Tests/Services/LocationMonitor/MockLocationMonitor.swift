import Foundation

@testable import GM2023

class MockLocationMonitor: LocationMonitor {
    var currentLocation: String?
    var lastEnteredLocation: String?

    func start() {}
    func stop() {}
}
