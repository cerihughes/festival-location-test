import Foundation

class AddAreaViewModel {
    private let locationRepository: LocationRepository
    private let locationManager: LocationManager
    private let existingAreaNames: [String]

    var location: Location? {
        didSet {
            isValid = checkValidity()
        }
    }

    var areaName: String? {
        didSet {
            isValid = checkValidity()
        }
    }

    var isValid = false

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
        self.locationRepository = locationRepository
        self.locationManager = locationManager
        existingAreaNames = locationRepository.areas().map { $0.name }
    }

    func useCurrentLocation() async -> Location? {
        guard let current = await locationManager.getLocation() else { return nil }
        location = current
        return location
    }

    func create() -> Bool {
        guard let areaName, let location, isValid else { return false }
        let area = Area.create(name: areaName, location: location)
        locationRepository.addArea(area)
        return true
    }

    private func checkValidity() -> Bool {
        guard location != nil, let areaName else { return false }
        return !existingAreaNames.contains(areaName)
    }
}
