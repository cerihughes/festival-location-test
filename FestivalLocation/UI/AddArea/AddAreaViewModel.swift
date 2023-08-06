import Foundation
import MapKit

class AddAreaViewModel {
    private let locationRepository: LocationRepository
    private let locationManager: LocationManager
    private let existingAreaNames: [String]
    private let radiusFormatter = NumberFormatter.createMeters()

    var location: Location? {
        didSet {
            isValid = checkValidity()
        }
    }

    var radius: Float = 50.0

    var areaName: String? {
        didSet {
            isValid = checkValidity()
        }
    }

    var overlay: MKCircle? {
        createCircularArea()?.asMapCircle()
    }

    var radiusDisplayString: String {
        radiusFormatter.string(from: .init(value: radius)) ?? "000m"
    }

    var isValid = false

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
        self.locationRepository = locationRepository
        self.locationManager = locationManager
        existingAreaNames = locationRepository.areas().map { $0.name }
    }

    func getCurrentLocation() async -> Location? {
        await locationManager.getLocation()
    }

    func addLocation(_ location: Location) {

    }

    func create() -> Bool {
        guard let areaName, let circularArea = createCircularArea(), isValid else { return false }
        let area = Area.create(name: areaName, circularArea: circularArea)
        locationRepository.addArea(area)
        return true
    }

    private func createCircularArea() -> CircularArea? {
        location.map { CircularArea(location: $0, radius: .init(radius)) }
    }

    private func checkValidity() -> Bool {
        guard location != nil, let areaName else { return false }
        return !existingAreaNames.contains(areaName)
    }
}

private extension CircularArea {
    func with(radius: Float) -> Self {
        .init(location: location, radius: .init(radius))
    }
}
