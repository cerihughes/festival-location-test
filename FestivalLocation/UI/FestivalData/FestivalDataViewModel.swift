import Foundation

class FestivalDataViewModel {
    private let dataRepository: DataRepository
    private let dataLoader: DataLoader

    private let timeFormatter = DateFormatter.create(dateStyle: .none)

    private var slots = [FestivalSlotTableViewCell.ViewData]()

    init(dataRepository: DataRepository, dataLoader: DataLoader) {
        self.dataRepository = dataRepository
        self.dataLoader = dataLoader
        loadData()
        updateSlots()
    }

    var selectedDay: FestivalDataView.Day = .thursday {
        didSet {
            updateSlots()
        }
    }

    var selectedStage: FestivalDataView.Stage = .mountain {
        didSet {
            updateSlots()
        }
    }

    var numberOfSlots: Int {
        slots.count
    }

    @discardableResult
    func loadData() -> Bool {
        dataLoader.loadData()
    }

    func viewData(at index: Int) -> FestivalSlotTableViewCell.ViewData? {
        slots[safe: index]
    }

    private func updateSlots() {
        guard let stage = dataRepository.stage(name: selectedStage.identifier) else { return }
        let dayStart = selectedDay.start
        let dayEnd = selectedDay.end
        slots = stage.slots
            .filter { dayStart...dayEnd ~= $0.start }
            .mapWithPrevious {
                $0.asViewData(timeFormatter: timeFormatter, isPreviousSlotFinished: $1?.isFinished ?? true)
            }
    }
}

private extension FestivalDataView.Stage {
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
        case .roundTheTwist:
            return "Round The Twist"
        }
    }
}

private extension Slot {
    var isFinished: Bool {
        end <= Date()
    }

    func asViewData(timeFormatter: DateFormatter, isPreviousSlotFinished: Bool) -> FestivalSlotTableViewCell.ViewData {
        let time = "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
        let timeStatus = timeStatus(isPreviousSlotFinished: isPreviousSlotFinished)
        return .init(name: name, time: time, timeStatus: timeStatus, visited: false)
    }

    private func timeStatus(isPreviousSlotFinished: Bool) -> FestivalSlotTableViewCell.TimeStatus {
        let now = Date()
        let started = start <= now
        let finished = end <= now
        switch (isPreviousSlotFinished, started, finished) {
        case (_, _, true):
            return .past
        case (_, true, false):
            return .current
        case (true, false, false):
            return .pending
        case (false, false, false):
            return .future
        }
    }
}

private extension FestivalDataView.Day {
    var start: Date {
        Calendar.current.date(self)
    }

    var end: Date {
        start.addingOneDay()
    }
}

private extension Calendar {
    func date(_ day: FestivalDataView.Day) -> Date {
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
