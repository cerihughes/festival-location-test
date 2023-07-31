import Foundation
import RealmSwift

protocol LocationRepository {
    func getAll<T>(_ type: T.Type) -> Results<T> where T: Object
    func add<T>(_ object: T) where T: Object
}

extension LocationRepository {
    func areas() -> Results<Area> {
        getAll(Area.self)
    }

    func addArea(_ area: Area) {
        add(area)
    }

    func visits() -> Results<Visit> {
        getAll(Visit.self)
    }

    func addVisit(_ visit: Visit) {
        add(visit)
    }
}
