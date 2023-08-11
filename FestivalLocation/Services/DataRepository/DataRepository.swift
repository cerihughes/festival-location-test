import RealmSwift

protocol DataRepository {
    func getAll<T>(_ type: T.Type) -> Results<T> where T: Object
    func add<T>(_ object: T) where T: Object
}

extension DataRepository {
    func areas() -> Results<Area> {
        getAll(Area.self)
    }

    func area(name: String) -> Area? {
        areas()
            .where { $0.name == name }
            .first
    }

    func events(areaName: String) -> Results<Event> {
        getAll(Event.self)
            .where { $0.areaName == areaName }
            .sorted(by: \.timestamp)
    }

    }
}

class RealmDataRepository: DataRepository {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func getAll<T>(_ type: T.Type) -> Results<T> where T: Object {
        realm.objects(type)
    }

    func add<T>(_ object: T) where T: Object {
        try? realm.write {
            realm.add(object)
        }
    }
}
