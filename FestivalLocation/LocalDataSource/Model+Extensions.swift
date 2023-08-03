import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func asLocation() -> Location {
        .init(lat: latitude, lon: longitude)
    }
}

extension Location {
    func asCoordinate() -> CLLocationCoordinate2D {
        .init(latitude: lat, longitude: lon)
    }

    static func + (left: Location, right: Location) -> Location {
        .init(lat: left.lat + right.lat, lon: left.lon + right.lon)
    }
}
