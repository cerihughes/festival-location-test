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
