import Foundation

protocol LocationMonitor {
    func start()
    func stop()
}

class DefaultLocationMonitor: LocationMonitor {
    private let locationManager: LocationManager
    private let locationRepository: LocationRepository

    private var collectionNotificationToken: NSObject?
    private var areaNotificationTokens = [NSObject]()

    init(locationManager: LocationManager, locationRepository: LocationRepository) {
        self.locationManager = locationManager
        self.locationRepository = locationRepository
    }

    func start() {
        collectionNotificationToken = locationRepository.areas().observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case let .initial(areas):
                areaNotificationTokens = areas.map(monitorArea(_:))
            case let .update(areas, _, insertions, _):
                for insertion in insertions {
                    areaNotificationTokens.append(areas[insertion])
                }
            case .error:
                break // No-op
            }
        }
    }

    func stop() {
        collectionNotificationToken = nil
        locationRepository.areas()
            .map { $0.name }
            .forEach { locationManager.stopMonitoring(name: $0) }
    }

    private func monitorArea(_ area: Area) -> NSObject {
        let name = area.name
        return area.observe { [weak self] change in
            if case .deleted = change {
                self?.locationManager.stopMonitoring(name: name)
            }
        }
    }
}

extension DefaultLocationMonitor: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didEnter location: Location, name: String) {
        let visit = Visit.entry(name: name)
        locationRepository.addVisit(visit)
    }

    func locationManager(_ locationManager: LocationManager, didExit location: Location, name: String) {
        let visit = Visit.exit(name: name)
        locationRepository.addVisit(visit)
    }
}

private extension Visit {
    static func entry(name: String) -> Visit {
        .create(name: name, kind: .entry)
    }

    static func exit(name: String) -> Visit {
        .create(name: name, kind: .exit)
    }

    private static func create(name: String, kind: Kind) -> Visit {
        create(name: name, timestamp: Date(), kind: kind)
    }
}
