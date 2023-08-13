import Foundation
import RealmSwift

// swiftlint: disable identifier_name
class UniqueObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
}
// swiftlint: enable identifier_name

class Area: UniqueObject {
    @Persisted var name: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var radius: Double
}

class Event: UniqueObject {
    enum Kind: String, PersistableEnum {
        case entry, exit
    }

    @Persisted var areaName: String
    @Persisted var timestamp: Date
    @Persisted var kind: Kind = .entry
}

class Festival: UniqueObject {
    @Persisted var name: String
    @Persisted var stages: List<Stage>
}

class Stage: UniqueObject {
    @Persisted var name: String
    @Persisted var slots: List<Slot>
    @Persisted(originProperty: "stages") var festival: LinkingObjects<Festival>
}

class Slot: EmbeddedObject {
    @Persisted var name: String
    @Persisted var start: Date
    @Persisted var end: Date
}

extension UniqueObject {
    var stringIdentifier: String {
        _id.stringValue
    }
}

extension Area {
    static func create(name: String, latitude: Double, longitude: Double, radius: Double) -> Area {
        let area = Area()
        area.name = name
        area.latitude = latitude
        area.longitude = longitude
        area.radius = radius
        return area
    }
}

extension Event {
    static func create(areaName: String, timestamp: Date, kind: Kind) -> Event {
        let event = Event()
        event.areaName = areaName
        event.timestamp = timestamp
        event.kind = kind
        return event
    }
}

extension Festival {
    static func create(name: String) -> Festival {
        let festival = Festival()
        festival.name = name
        return festival
    }
}

extension Stage {
    static func create(name: String) -> Stage {
        let stage = Stage()
        stage.name = name
        return stage
    }
}

extension Slot {
    static func create(name: String, start: Date, end: Date) -> Slot {
        let slot = Slot()
        slot.name = name
        slot.start = start
        slot.end = end
        return slot
    }
}
