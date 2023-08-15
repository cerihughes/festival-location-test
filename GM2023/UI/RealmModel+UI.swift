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

extension NowNext {
    func body(timeFormatter: DateFormatter) -> String {
        var body = nowBody(timeFormatter: timeFormatter)
        if let nextBody = nextBody(timeFormatter: timeFormatter) {
            body += "\n"
            body += nextBody
        }
        return body
    }

    private func nowBody(timeFormatter: DateFormatter) -> String {
        if isNowStarted {
            return "Now: \(now.name)"
        } else {
            return now.body(timeFormatter: timeFormatter)
        }
    }

    private func nextBody(timeFormatter: DateFormatter) -> String? {
        guard let next else { return nil }
        return next.body(timeFormatter: timeFormatter)
    }
}

private extension Slot {
    func body(timeFormatter: DateFormatter) -> String {
        return "\(timeFormatter.string(from: start)): \(name)"
    }
}
