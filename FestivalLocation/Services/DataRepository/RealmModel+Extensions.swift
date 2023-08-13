import Foundation

extension Area {
    static func create(circularArea: CircularArea) -> Area {
        create(name: circularArea.name, location: circularArea.location, radius: circularArea.radius)
    }

    static func create(name: String, location: Location, radius: Double) -> Area {
        create(name: name, latitude: location.latitude, longitude: location.longitude, radius: radius)
    }

    var location: Location {
        .init(latitude: latitude, longitude: longitude)
    }

    func asCircularArea() -> CircularArea {
        .init(name: name, location: location, radius: radius)
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
        create(areaName: areaName, timestamp: dateFactory.currentDate(), kind: kind)
    }
}
