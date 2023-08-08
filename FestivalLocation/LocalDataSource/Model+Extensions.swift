import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func asLocation() -> Location {
        .init(latitude: latitude, longitude: longitude)
    }
}

extension MKCircle {
    func asCircularArea() -> CircularArea {
        .init(location: coordinate.asLocation(), radius: radius)
    }
}

extension Location {
    func asMapCoordinate() -> CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

    static func + (left: Location, right: Location) -> Location {
        .init(latitude: left.latitude + right.latitude, longitude: left.longitude + right.longitude)
    }
}

extension CircularArea {
    func asMapCircle() -> MKCircle {
        .init(center: location.asMapCoordinate(), radius: radius)
    }
}
