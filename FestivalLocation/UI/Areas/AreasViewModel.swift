import Foundation

class AreasViewModel {
    private let locationRepository: LocationRepository
    private let locationManager: LocationManager

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
        self.locationRepository = locationRepository
        self.locationManager = locationManager
    }

    func authoriseIfNeeded() {
        if locationManager.authorisationStatus != .accepted {
            locationManager.authorise()
        }
    }

    func createRegionAtCurrentLocation() async {
        guard let current = await locationManager.getLocation() else { return }
        return createRegion(at: current)
    }

    func createRegion(at location: Location) {
        let area = Area.create(name: "Region", location: location)
        DispatchQueue.main.async { [weak self] in
            self?.locationRepository.addArea(area)
        }
    }
}
