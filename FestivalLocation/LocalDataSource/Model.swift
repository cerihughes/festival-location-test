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
}

class Visit: UniqueObject {
    enum Kind: String {
        case entry, exit
    }

    @Persisted var name: String
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

extension Area {
    static func create(name: String, latitude: Double, longitude: Double) -> Area {
        let area = Area()
        area.name = name
        area.latitude = latitude
        area.longitude = longitude
        return area
    }
}

extension Visit {
    static func create(name: String, timestamp: Date, kind: Kind) -> Visit {
        let visit = Visit()
        visit.name = name
        visit.timestamp = timestamp
        visit.kind = kind
        return visit
    }
}
