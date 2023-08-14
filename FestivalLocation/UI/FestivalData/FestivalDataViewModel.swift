import Foundation

class FestivalDataViewModel {
    private let dataRepository: DataRepository
    private let lineupLoader: LineupLoader

    private let timeFormatter = DateFormatter.create(dateStyle: .none)

    private var slots = [FestivalSlotTableViewCell.ViewData]()

    init(dataRepository: DataRepository, lineupLoader: LineupLoader) {
        self.dataRepository = dataRepository
        self.lineupLoader = lineupLoader
        importLineup()
        updateSlots()
    }

    var selectedDay: GMDay = .currentOrThursday {
        didSet {
            updateSlots()
        }
    }

    var selectedStage: GMStage = .initialStage(for: .currentOrThursday) {
        didSet {
            updateSlots()
        }
    }

    var indexOfSelectedDay: Int {
        GMDay.allCases.firstIndex(of: selectedDay) ?? 0
    }

    var indexOfSelectedStage: Int {
        GMStage.allCases.firstIndex(of: selectedStage) ?? 0
    }

    var indexToScrollTo: Int? {
        guard selectedDay == .current else { return nil }
        return slots.firstIndex { $0.timeStatus == .pending || $0.timeStatus == .current } ?? slots.indices.last
    }

    var numberOfSlots: Int {
        slots.count
    }

    var stagesForSelectedDay: [GMStage] {
        GMStage.stages(for: selectedDay)
    }

    @discardableResult
    func importLineup() -> Bool {
        lineupLoader.importLineup()
    }

    func viewData(at index: Int) -> FestivalSlotTableViewCell.ViewData? {
        slots[safe: index]
    }

    private func updateSlots() {
        guard
            let stage = dataRepository.stage(name: selectedStage.identifier),
            let daySlots = stage.slots(for: selectedDay)
        else { return }

        slots = daySlots.mapWithPrevious {
            $0.asViewData(timeFormatter: timeFormatter, isPreviousSlotFinished: $1?.isFinished ?? true)
        }
    }
}

private extension GMDay {
    static var currentOrThursday: Self {
        current ?? .thursday
    }
}

private extension GMStage {
    static func stages(for day: GMDay) -> [GMStage] {
        day == .thursday ? [.farOut, .walledGarden, .chaiWallahs, .roundTheTwist] : GMStage.allCases
    }

    static func initialStage(for day: GMDay) -> GMStage {
        stages(for: day).first ?? .mountain
    }

    var next: Self? {
        .init(rawValue: rawValue + 1)
    }

    var previous: Self? {
        .init(rawValue: rawValue - 1)
    }
}

private extension Slot {
    var isFinished: Bool {
        end <= dateFactory.currentDate()
    }

    func asViewData(timeFormatter: DateFormatter, isPreviousSlotFinished: Bool) -> FestivalSlotTableViewCell.ViewData {
        let timeStatus = timeStatus(isPreviousSlotFinished: isPreviousSlotFinished)
        return .init(name: name, time: timeString(timeFormatter: timeFormatter), timeStatus: timeStatus, visited: false)
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
