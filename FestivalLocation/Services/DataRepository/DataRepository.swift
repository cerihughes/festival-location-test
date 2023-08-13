import Foundation
import RealmSwift

protocol DataRepository {
    func getAll<T>(_ type: T.Type) -> Results<T> where T: Object
    func add<T>(_ object: T) where T: Object
    func delete(_ object: Object)
    func commit(_ block: (() -> Void))
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

    func festivals() -> Results<Festival> {
        getAll(Festival.self)
    }

    func festival(name: String) -> Festival? {
        festivals()
            .where { $0.name == name }
            .first
    }

    func delete(festival: Festival) {
        for stage in festival.stages {
            delete(stage)
        }
        delete(festival)
    }

    func recreateFestival(name: String) -> Festival {
        if let existing = festival(name: name) {
            delete(festival: existing)
        }
        let festival = Festival.create(name: name)
        add(festival)
        return festival
    }

    func stage(name: String) -> Stage? {
        getAll(Stage.self)
            .where { $0.name == name }
            .first
    }

    func getOrCreateStage(in festival: Festival, name: String) -> Stage {
        if let existing = festival.stages.filter({ $0.name == name }).first {
            return existing
        }
        let stage = Stage.create(name: name)
        commit {
            festival.stages.append(stage)
        }
        return stage
    }

    func createSlot(name: String, start: Date, end: Date, on stage: Stage) {
        let slot = Slot.create(name: name, start: start, end: end)
        commit {
            stage.slots.append(slot)
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
        commit {
            realm.add(object)
        }
    }

    func delete(_ object: Object) {
        commit {
            realm.delete(object)
        }
    }

    func commit(_ block: (() -> Void)) {
        try? realm.write(block)
    }

}
