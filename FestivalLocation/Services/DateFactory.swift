import Foundation

var dateFactory: DateFactory = DefaultDateFactory()

protocol DateFactory {
    func currentDate() -> Date
}

class DefaultDateFactory: DateFactory {
    func currentDate() -> Date {
        .now
    }
}

#if DEBUG
class DebugDateFactory: DateFactory {
    private let dateFormatter = DateFormatter.dd_MM_yyyy_HH_mm()

    func currentDate() -> Date {
        dateFormatter.date(from: "20.08.2023 00:40") ?? .now
    }
}
#endif
