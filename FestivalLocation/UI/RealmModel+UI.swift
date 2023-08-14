import Foundation

protocol TimeFormattable {
    var timeFormatter: DateFormatter { get }
}

extension TimeFormattable {
    func timeString(for slot: Slot) -> String {
        slot.timeString(timeFormatter: timeFormatter)
    }
}

extension Slot {
    func timeString(timeFormatter: DateFormatter) -> String {
        "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
    }
}
