import Foundation

@testable import GM2023

class MockDateFactory: DateFactory {
    private let dateFormatter = DateFormatter.dd_MM_yyyy_HH_mm()

    init() {
        setCurrentDate("11.08.2024 12:00")
    }

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
