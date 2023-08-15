import Foundation

protocol LocalStorage: AnyObject {
    func bool(forKey key: String) -> Bool
    func setBool(_ value: Bool, forKey key: String)
}

extension UserDefaults: LocalStorage {
    func setBool(_ value: Bool, forKey key: String) {
        setValue(value, forKey: key)
    }
}
