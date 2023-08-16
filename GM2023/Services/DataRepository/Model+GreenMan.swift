import Foundation

enum GMDay: Int, CaseIterable {
    case thursday, friday, saturday, sunday
}

enum GMStage: Int, CaseIterable {
    case mountain, farOut, walledGarden, rising, chaiWallahs, babblingTongues, cinedrome, roundTheTwist
}

extension GMDay {
    var start: Date {
        Calendar.current.date(self)
    }

    var end: Date {
        start.addingOneDay()
    }

    static var current: Self? {
        let now = dateFactory.currentDate()
        for day in allCases where day.start ... day.end ~= now {
            return day
        }
        return nil
    }

    var dateString: String {
        switch self {
        case .thursday:
            return "17.08.2023"
        case .friday:
            return "18.08.2023"
        case .saturday:
            return "19.08.2023"
        case .sunday:
            return "20.08.2023"
        }
    }

    func dd_MM_yyyy_HH_mm(time: String) -> String {
        "\(dateString) \(time)"
    }
}

extension GMStage {
    private static let identifiers = GMStage.allCases.map { $0.identifier }

    static func create(identifier: String) -> GMStage? {
        guard let index = identifiers.firstIndex(of: identifier) else { return nil }
        return GMStage(rawValue: index)
    }

    var identifier: String {
        switch self {
        case .mountain:
            return "Mountain Stage"
        case .farOut:
            return "Far Out"
        case .walledGarden:
            return "Walled Garden"
        case .rising:
            return "Rising"
        case .chaiWallahs:
            return "Chai Wallahs"
        case .babblingTongues:
            return "Babbling Tongues"
        case .cinedrome:
            return "Cinedrome"
        case .roundTheTwist:
            return "Round The Twist"
        }
    }
}

extension Calendar {
    func date(_ day: GMDay) -> Date {
        // Assume a festival day runs from 6am to 6am
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 8
        dateComponents.day = 17 + day.rawValue
        dateComponents.timeZone = TimeZone(abbreviation: "BST")
        dateComponents.hour = 6
        return date(from: dateComponents)!
    }
}
