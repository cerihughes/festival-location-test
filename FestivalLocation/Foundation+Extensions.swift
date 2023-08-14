import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension Collection where Element: Equatable {
    func element(after firstElement: Element) -> Element? {
        var iterator = makeIterator()
        while let next = iterator.next() {
            if next == firstElement {
                return iterator.next()
            }
        }
        return nil
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        Array(Set(self))
    }
}

extension Sequence {
    @inlinable func mapWithPrevious<T>(_ transform: (Element, Element?) -> T) -> [T] {
        var lastElement: Element?
        return reduce(into: []) { partialResult, element in
            partialResult.append(transform(element, lastElement))
            lastElement = element
        }
    }
}

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
}

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespaces)
    }
}

extension Date {
    func addingOneDay() -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
}

extension NumberFormatter {
    static func createMeters() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 2
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.positiveSuffix = "m"
        return formatter
    }
}

extension DateFormatter {
    static func create(
        dateStyle: DateFormatter.Style = .short,
        timeStyle: DateFormatter.Style = .short
    ) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter
    }

    static func HH_mm() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }

    static func dd_MM_yyyy() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }

    static func dd_MM_yyyy_HH_mm() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }
}

extension Bundle {
    func url(for fileName: String) -> URL? {
        let nsString = fileName as NSString
        return url(forResource: nsString.deletingPathExtension, withExtension: nsString.pathExtension)
    }
}
