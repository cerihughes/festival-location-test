import RealmSwift

class DefaultLocationRepository: LocationRepository {
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
