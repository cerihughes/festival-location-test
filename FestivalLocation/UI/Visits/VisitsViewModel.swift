import Foundation
import RealmSwift

protocol VisitsViewModelDelegate: AnyObject {
    func visitsViewModelDidUpdate(_ visitsViewModel: VisitsViewModel)
}

class VisitsViewModel {
    struct VisitViewData: Equatable {
        let title: String
    }
    private let areaName: String
    private let dataRepository: DataRepository
    private let dateFormatter = DateFormatter.create()

    private var collectionNotificationToken: NSObject?

    private var allVisits = [VisitViewData]() {
        didSet {
            guard allVisits != oldValue else { return }
            delegate?.visitsViewModelDidUpdate(self)
        }
    }

    weak var delegate: VisitsViewModelDelegate?

    init(areaName: String, dataRepository: DataRepository, locationManager: LocationManager) {
        self.areaName = areaName
        self.dataRepository = dataRepository

        observe()
    }

    var numberOfVisits: Int {
        allVisits.count
    }

    func visit(at index: Int) -> VisitViewData? {
        allVisits[safe: index]
    }

    private func createVisits(events: Results<Event>) {
        let builder = VisitBuilder(dataRepository: dataRepository)
        var processor: EventProcessor?
        for event in events {
            guard let processor else {
                processor = .init(builder: builder, lastEvent: event)
                continue
            }
            processor.processEvent(event)
        }

        if let visits = processor?.finish() {
            allVisits = visits.map { $0.asVisitViewData(dateFormatter: dateFormatter) }
        }
    }

    private func observe() {
        collectionNotificationToken = dataRepository.events(areaName: areaName).observe { [weak self] changes in
            switch changes {
            case .initial(let events), .update(let events, _, _, _):
                self?.createVisits(events: events)
            default:
                break // No-op
            }
        }
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

private extension Visit {
    func asVisitViewData(dateFormatter: DateFormatter) -> VisitsViewModel.VisitViewData {
        .init(title: title(dateFormatter: dateFormatter))
    }

    private func title(dateFormatter: DateFormatter) -> String {
        if let end {
            return "Visit from \(dateFormatter.string(from: start)) to \(dateFormatter.string(from: end))"
        } else {
            return "Ongoing visit from \(dateFormatter.string(from: start))"
        }
    }
}
