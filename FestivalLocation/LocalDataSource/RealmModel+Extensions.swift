import Foundation

extension Area {
    static func create(name: String, location: Location) -> Area {
        create(name: name, latitude: location.lat, longitude: location.lon)
    }

    var location: Location {
        .init(lat: latitude, lon: longitude)
    }
}

extension Event {
    static func entry(areaName: String) -> Event {
        .create(areaName: areaName, kind: .entry)
    }

    static func exit(areaName: String) -> Event {
        .create(areaName: areaName, kind: .exit)
    }

    private static func create(areaName: String, kind: Kind) -> Event {
        create(areaName: areaName, timestamp: Date(), kind: kind)
    }
}
