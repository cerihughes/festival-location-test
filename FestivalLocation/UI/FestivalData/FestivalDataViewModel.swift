import Foundation

class FestivalDataViewModel {
    private let dataRepository: DataRepository
    private let lineupLoader: LineupLoader

    private let timeFormatter = DateFormatter.create(dateStyle: .none)

    private var slots = [FestivalSlotTableViewCell.ViewData]()

    init(dataRepository: DataRepository, lineupLoader: LineupLoader) {
        self.dataRepository = dataRepository
        self.lineupLoader = lineupLoader
        loadData()
        updateSlots()
    }

    var selectedDay: FestivalDataView.Day = .currentOrThursday {
        didSet {
            updateSlots()
        }
    }

    var selectedStage: FestivalDataView.Stage = .initialStage(for: .currentOrThursday) {
        didSet {
            updateSlots()
        }
    }

    var indexOfSelectedDay: Int {
        FestivalDataView.Day.allCases.firstIndex(of: selectedDay) ?? 0
    }

    var indexOfSelectedStage: Int {
        FestivalDataView.Stage.allCases.firstIndex(of: selectedStage) ?? 0
    }

    var indexToScrollTo: Int? {
        guard selectedDay == .current else { return nil }
        return slots.firstIndex { $0.timeStatus == .pending || $0.timeStatus == .current } ?? slots.indices.last
    }

    var numberOfSlots: Int {
        slots.count
    }

    var stagesForSelectedDay: [FestivalDataView.Stage] {
        FestivalDataView.Stage.stages(for: selectedDay)
    }

    @discardableResult
    func loadData() -> Bool {
        lineupLoader.loadData()
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

private extension FestivalDataView.Day {
    var start: Date {
        Calendar.current.date(self)
    }

    var end: Date {
        start.addingOneDay()
    }

    static var current: Self? {
        let now = dateFactory.currentDate()
        for day in allCases where day.start...day.end ~= now {
            return day
        }
        return nil
    }

    static var currentOrThursday: Self {
        current ?? .thursday
    }
}

private extension FestivalDataView.Stage {
    static func stages(for day: FestivalDataView.Day) -> [FestivalDataView.Stage] {
        day == .thursday ? [.farOut, .walledGarden, .chaiWallahs, .roundTheTwist] : FestivalDataView.Stage.allCases
    }

    static func initialStage(for day: FestivalDataView.Day) -> FestivalDataView.Stage {
        stages(for: day).first ?? .mountain
    }

    var next: Self? {
        .init(rawValue: rawValue + 1)
    }

    var previous: Self? {
        .init(rawValue: rawValue - 1)
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
        case .roundTheTwist:
            return "Round The Twist"
        }
    }
}

private extension Slot {
    var isFinished: Bool {
        end <= dateFactory.currentDate()
    }

    func asViewData(timeFormatter: DateFormatter, isPreviousSlotFinished: Bool) -> FestivalSlotTableViewCell.ViewData {
        let time = "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
        let timeStatus = timeStatus(isPreviousSlotFinished: isPreviousSlotFinished)
        return .init(name: name, time: time, timeStatus: timeStatus, visited: false)
    }

    private func timeStatus(isPreviousSlotFinished: Bool) -> FestivalSlotTableViewCell.TimeStatus {
        let now = dateFactory.currentDate()
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
