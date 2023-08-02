import Foundation
import MapKit

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

extension Area {
    static func create(name: String, location: Location) -> Area {
        create(name: name, latitude: location.lat, longitude: location.lon)
    }

    var location: Location {
        .init(lat: latitude, lon: longitude)
    }
}

extension Visit {
    static func entry(name: String) -> Visit {
        .create(name: name, kind: .entry)
    }

    static func exit(name: String) -> Visit {
        .create(name: name, kind: .exit)
    }

    private static func create(name: String, kind: Kind) -> Visit {
        create(name: name, timestamp: Date(), kind: kind)
    }
}
