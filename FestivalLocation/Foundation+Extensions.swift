import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}

extension DateFormatter {
    static func create() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
