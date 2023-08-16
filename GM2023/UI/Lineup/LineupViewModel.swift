import Foundation

class LineupViewModel {
    private let localDataSource: LocalDataSource
    private let dataRepository: DataRepository
    private let locationMonitor: LocationMonitor

    private let timeFormatter = DateFormatter.HH_mm()

    private var viewData = [LineupTableViewCell.ViewData]()

    init(localDataSource: LocalDataSource, dataRepository: DataRepository, locationMonitor: LocationMonitor) {
        self.localDataSource = localDataSource
        self.dataRepository = dataRepository
        self.locationMonitor = locationMonitor
        selectedStage = .initialStage(for: .currentOrThursday, stagesToShow: stagesToShow)
        updateViewData()
    }

    var selectedDay: GMDay = .currentOrThursday {
        didSet {
            updateViewData()
        }
    }

    var selectedStage: GMStage = .mountain {
        didSet {
            updateViewData()
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
        return viewData.firstIndex { $0.timeStatus == .pending || $0.timeStatus == .current } ?? viewData.indices.last
    }

    var numberOfSlots: Int {
        viewData.count
    }

    var stagesToShow: [GMStage] {
        localDataSource.stagesToShow
    }

    var stagesForSelectedDay: [GMStage] {
        GMStage.stages(for: selectedDay)
    }

    func updateForLocalStage() {
        guard
            selectedDay == GMDay.current,
            let location = locationMonitor.currentLocation,
            let stage = GMStage.create(identifier: location)
        else {
            return
        }

        selectedStage = stage
    }

    func viewData(at index: Int) -> LineupTableViewCell.ViewData? {
        viewData[safe: index]
    }

    private func updateViewData() {
        guard
            let stage = dataRepository.stage(name: selectedStage.identifier),
            let daySlots = stage.slots(for: selectedDay)
        else { return }

        let isToday = selectedDay == .current
        viewData = daySlots.enumerated().mapWithPrevious {
            $0.element.asViewData(
                index: $0.offset,
                timeFormatter: timeFormatter,
                isPreviousFinished: $1?.element.isFinished ?? true,
                isToday: isToday
            )
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
        day == .thursday ? [.farOut, .walledGarden, .chaiWallahs, .cinedrome, .roundTheTwist] : GMStage.allCases
    }

    static func initialStage(for day: GMDay, stagesToShow: [GMStage]) -> GMStage {
        stages(for: day).filter { stagesToShow.contains($0) }.first ?? .mountain
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

    func asViewData(
        index: Int,
        timeFormatter: DateFormatter,
        isPreviousFinished: Bool,
        isToday: Bool
    ) -> LineupTableViewCell.ViewData {
        let timeStatus = timeStatus(isPreviousFinished: isPreviousFinished, isToday: isToday)
        return .init(
            isEven: index.isEven,
            name: name,
            time: timeString(timeFormatter: timeFormatter),
            timeStatus: timeStatus,
            visited: false
        )
    }

    private func timeStatus(isPreviousFinished: Bool, isToday: Bool) -> LineupTableViewCell.TimeStatus {
        let now = dateFactory.currentDate()
        let started = start <= now
        let finished = end <= now
        switch (isPreviousFinished, started, finished) {
        case (_, _, true):
            return .past
        case (_, true, false):
            return .current
        case (true, false, false):
            return isToday ? .pending : .future
        case (false, false, false):
            return .future
        }
    }
}

private extension LocalDataSource {
    var stagesToShow: [GMStage] {
        GMStage.allCases.filter { isStageShowing($0) }
    }
}
