import Foundation
import RealmSwift

class Area: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
}

class Visit: Object {
    enum Kind: String {
        case entry, exit
    }

    @Persisted(primaryKey: true) var id: ObjectId
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
