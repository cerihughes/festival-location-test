import Foundation
import RealmSwift

protocol HistoryViewModelDelegate: AnyObject {
    func historyViewModelDidUpdate(_ historyViewModel: HistoryViewModel)
}

class HistoryViewModel {
    private let areaName: String
    private let dataRepository: DataRepository

    private var collectionNotificationToken: NSObject?

    private var viewData = [HistoryTableViewCell.ViewData]() {
        didSet {
            delegate?.historyViewModelDidUpdate(self)
        }
    }

    weak var delegate: HistoryViewModelDelegate?

    init(areaName: String, dataRepository: DataRepository, locationManager: LocationManager) {
        self.areaName = areaName
        self.dataRepository = dataRepository

        observe()
    }

    var numberOfItems: Int {
        viewData.count
    }

    func viewData(at index: Int) -> HistoryTableViewCell.ViewData? {
        viewData[safe: index]
    }

    private func createViewData(events: Results<Event>) {
        let builder = VisitBuilder(dataRepository: dataRepository)
        var processor: EventProcessor?
        for event in events {
            guard let processor else {
                processor = .init(builder: builder, lastEvent: event)
                continue
            }
            processor.processEvent(event)
        }

        guard let visits = processor?.finish() else { return }

        viewData = visits.map { dataRepository.slotTimings(during: $0) }
            .reduce([:]) { $0.mergingAndAdding(other: $1) }
            .map { $0 }
            .sorted { $0.key.start < $1.key.start }
            .enumerated()
            .compactMap { HistoryTableViewCell.ViewData.create(index: $0.offset, tuple: $0.element) }
    }

    private func observe() {
        collectionNotificationToken = dataRepository.events(areaName: areaName).observe { [weak self] changes in
            switch changes {
            case let .initial(events), let .update(events, _, _, _):
                self?.createViewData(events: events)
            default:
                break // No-op
            }
        }
    }
}

private extension DataRepository {
    func slots(during visit: Visit) -> [Slot] {
        guard let stage = stage(name: visit.areaName) else { return [] }
        return stage.slots
            .filter { visit.didSee(slot: $0) }
            .asArray()
    }

    func slotTimings(during visit: Visit) -> [Slot: TimeInterval] {
        slots(during: visit).reduce(into: [:]) {
            $0[$1] = visit.secondsSpent(at: $1)
        }
    }
}

private extension Visit {
    func secondsSpent(at slot: Slot) -> TimeInterval? {
        guard let end else { return nil }
        let overlapStart = max(start, slot.start)
        let overlapEnd = min(end, slot.end)
        return overlapEnd.timeIntervalSince(overlapStart)
    }

    func didSee(slot: Slot) -> Bool {
        guard let dateRange else { return false }
        return dateRange.overlaps(slot.dateRange)
    }
}

private class EventProcessor {
    private let builder: VisitBuilder
    private var lastEvent: Event
    private var visits = [Visit]()

    init(builder: VisitBuilder, lastEvent: Event) {
        self.builder = builder
        self.lastEvent = lastEvent

        if lastEvent.kind == .entry {
            builder.areaName = lastEvent.areaName
            builder.start = lastEvent.timestamp
        }
    }

    func processEvent(_ nextEvent: Event) {
        switch (lastEvent.kind, nextEvent.kind) {
        case (.entry, .exit):
            process(entry: lastEvent, exit: nextEvent)
        case (.exit, .entry):
            process(exit: lastEvent, entry: nextEvent)
        case (.entry, .entry):
            process(entry1: lastEvent, entry2: nextEvent)
        case (.exit, .exit):
            process(exit1: lastEvent, exit2: nextEvent)
        }
        lastEvent = nextEvent
    }

    func finish() -> [Visit] {
        // Check for an in progress visit (final event is an entry)
        build()
        return visits
    }

    private func process(entry: Event, exit: Event) {
        guard entry.areaName == exit.areaName else { return }
        builder.end = exit.timestamp
    }

    private func process(exit: Event, entry: Event) {
        build()
        builder.areaName = entry.areaName
        builder.start = entry.timestamp
    }

    private func process(entry1: Event, entry2: Event) {
        if entry1.areaName == entry2.areaName {
            // assume duplicate
            if let start = builder.start {
                builder.start = min(start, entry2.timestamp)
            } else {
                builder.start = entry2.timestamp
            }
        }
    }

    private func process(exit1: Event, exit2: Event) {
        if exit1.areaName == exit2.areaName {
            // assume duplicate
            if let end = builder.end {
                builder.end = max(end, exit2.timestamp)
            } else {
                builder.end = exit2.timestamp
            }
        }
    }

    private func build() {
        guard let visit = builder.build() else { return }
        visits.append(visit)
        builder.reset()
    }
}

private class VisitBuilder {
    private let dataRepository: DataRepository

    var start: Date?
    var end: Date?
    var areaName: String?

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }

    func build() -> Visit? {
        guard let start, let areaName, let location else { return nil }
        let visit = Visit(start: start, end: end, areaName: areaName, location: location)
        reset()
        return visit
    }

    func reset() {
        start = nil
        end = nil
        areaName = nil
    }

    private var location: Location? {
        guard let areaName else { return nil }
        return dataRepository.area(name: areaName)?.location
    }
}

private extension HistoryTableViewCell.ViewData {
    static func create(index: Int, tuple: (key: Slot, value: TimeInterval)) -> HistoryTableViewCell.ViewData? {
        let minutes = Int(tuple.value / 60.0)
        guard minutes >= 20 else { return nil }

        let name = tuple.key.name
        return .init(isEven: index.isEven, title: "\(name) for \(minutes) minutes")
    }
}
