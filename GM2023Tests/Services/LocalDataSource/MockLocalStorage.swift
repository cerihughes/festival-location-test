import Foundation

@testable import GM2023

class MockLocalStorage: LocalStorage {
    var storage = [String: Bool]()
    func bool(forKey key: String) -> Bool {
        storage[key] ?? false
    }

    func setBool(_ value: Bool, forKey key: String) {
        storage[key] = value
    }
}
