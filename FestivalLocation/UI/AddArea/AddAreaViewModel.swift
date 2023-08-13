import Foundation
import MapKit

class AddAreaViewModel {
    private let dataRepository: DataRepository
    private let locationManager: LocationManager
    private let existingAreaNames: [String]
    private let radiusFormatter = NumberFormatter.createMeters()

    private var location: Location?
    private var multipleLocations = [Location]()

    var mode = AddAreaView.Mode.single
    var areaName: String?
    var radius: Float = 50.0

    init(dataRepository: DataRepository, locationManager: LocationManager) {
        self.dataRepository = dataRepository
        self.locationManager = locationManager
        existingAreaNames = dataRepository.areas().map { $0.name }
    }

    var overlay: MKCircle? {
        createCircularArea()?.asMapCircle()
    }

    var annotations: [MKAnnotation] {
        switch mode {
        case .single:
            return [overlay].compactMap { $0 }
        case .multiple:
            return multipleLocations.map { LocationAnnotation(location: $0) }
        }
    }

    var radiusDisplayString: String {
        radiusFormatter.string(from: .init(value: determineRadius())) ?? "000m"
    }

    var isValid: Bool {
        guard let areaName, createCircularArea() != nil else { return false }
        return !existingAreaNames.contains(areaName)
    }

    private func determineRadius() -> Double {
        switch mode {
        case .single:
            return .init(radius)
        case .multiple:
            return createCircularArea()?.radius ?? 0
        }
    }

    func getCurrentLocation() async -> Location? {
        await locationManager.getLocation()
    }

    func useSingleLocation(_ location: Location) {
        self.location = location
    }

    func addLocation(_ point: Location) {
        multipleLocations.append(point)
    }

    func create() -> Bool {
        guard let circularArea = createCircularArea(), isValid else { return false }
        let area = Area.create(circularArea: circularArea)
        dataRepository.add(area)
        return true
    }

    private func createCircularArea() -> CircularArea? {
        guard let areaName else { return nil }
        switch mode {
        case .single:
            return location.map { CircularArea(name: areaName, location: $0, radius: .init(radius)) }
        case .multiple:
            guard let mapRect = multipleLocations.asMapRect() else { return nil }
            let circle = MKCircle.create(containing: mapRect)
            return circle.asCircularArea(name: areaName)
        }
    }
}

private extension Collection where Element == Location {
    func asMapRect() -> MKMapRect? {
        guard count > 1 else { return nil }
        let rects = map { MKMapRect(origin: MKMapPoint($0.asMapCoordinate()), size: MKMapSize()) }
        return rects.reduce(MKMapRect.null) { $0.union($1) }
    }
}

class LocationAnnotation: NSObject, MKAnnotation {
    private let location: Location

    init(location: Location) {
        self.location = location
    }

    var coordinate: CLLocationCoordinate2D {
        location.asMapCoordinate()
    }
}

private extension MKCircle {
    static func create(containing rect: MKMapRect) -> MKCircle {
        let containedCircle = MKCircle(mapRect: rect)
        let radius = containedCircle.radius
        return .init(
            center: containedCircle.coordinate,
            radius: ((radius * radius) + (radius * radius)).squareRoot()
        )
    }
}
