import Foundation

@testable import FestivalLocation

class MockDateFactory: DateFactory {
    private let dateFormatter = DateFormatter.dd_MM_yyyy_HH_mm()

    private var date: Date?

    func setCurrentDate(_ dateString: String) {
        date = dateFormatter.date(from: dateString)
    }

    func clearCurrentDate() {
        date = nil
    }

    func currentDate() -> Date {
        date ?? Date()
    }
}
