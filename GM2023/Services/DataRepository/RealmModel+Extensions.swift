import Foundation
import MapKit

extension String {
    static let greenMan2024FestivalName = "Green Man Festival 2024"
}

extension DataRepository {
    func hasGreenMan2024FestivalData() -> Bool {
        festival(name: .greenMan2024FestivalName) != nil
    }
}

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

    func asMapCircle() -> MKCircle {
        let circle = MKCircle(center: location.asMapCoordinate(), radius: radius)
        circle.title = name
        return circle
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

extension Stage {
    func slots(for day: GMDay) -> [Slot]? {
        slots.filter { day.start ... day.end ~= $0.start }
    }

    var todaySlots: [Slot]? {
        guard let current = GMDay.current else { return nil }
        return slots(for: current)
    }
}

extension Slot {
    var dateRange: ClosedRange<Date> {
        start ... end
    }
}
