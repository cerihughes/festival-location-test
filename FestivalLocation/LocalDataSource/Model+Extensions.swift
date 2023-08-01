import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func asLocation() -> Location {
        .init(lat: latitude, lon: longitude)
    }
}

extension Area {
    static func create(name: String, location: Location) -> Area {
        create(name: name, latitude: location.lat, longitude: location.lon)
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
