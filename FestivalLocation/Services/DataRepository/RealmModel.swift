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
    enum Kind: String {
        case entry, exit
    }

    @Persisted var areaName: String
    @Persisted var timestamp: Date
    @Persisted private var kindString: String

    var kind: Kind? {
        get {
            .init(rawValue: kindString)
        }
        set {
            kindString = newValue?.rawValue ?? ""
        }
    }
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
        let visit = Event()
        visit.areaName = areaName
        visit.timestamp = timestamp
        visit.kind = kind
        return visit
    }
}
