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

    func area(name: String) -> Area? {
        areas().filter { $0.name == name }
            .first
    }

    func addArea(_ area: Area) {
        add(area)
    }

    func events() -> Results<Event> {
        getAll(Event.self).sorted(by: \.timestamp)
    }

    func addEvent(_ visit: Event) {
        add(visit)
    }
}
