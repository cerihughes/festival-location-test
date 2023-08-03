import Foundation

protocol LocationMonitor {
    func start()
    func stop()
}

class DefaultLocationMonitor: LocationMonitor {
    private let locationManager: LocationManager
    private let locationRepository: LocationRepository
    private let notificationsManager: NotificationsManager

    private var collectionNotificationToken: NSObject?
    private var areaNotificationTokens = [String: NSObject]()

    init(
        locationManager: LocationManager,
        locationRepository: LocationRepository,
        notificationsManager: NotificationsManager
    ) {
        self.locationManager = locationManager
        self.locationRepository = locationRepository
        self.notificationsManager = notificationsManager

        locationManager.delegate = self
    }

    func start() {
        collectionNotificationToken = locationRepository.areas().observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case let .initial(areas):
                areas.forEach(monitorArea(_:))
            case let .update(areas, _, insertions, _):
                insertions.map { areas[$0] }
                    .forEach(monitorArea(_:))
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

    private func monitorArea(_ area: Area) {
        let name = area.name
        locationManager.startMonitoring(location: area.location, radius: 50, name: name)
        let token = area.observe { [weak self] change in
            if case .deleted = change {
                self?.locationManager.stopMonitoring(name: name)
            }
        }
        areaNotificationTokens[area.stringIdentifier] = token
    }
}

extension DefaultLocationMonitor: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didEnter location: Location, name: String) {
        let event = Event.entry(areaName: name)
        locationRepository.addEvent(event)
        notificationsManager.sendLocalNotification(for: event)
    }

    func locationManager(_ locationManager: LocationManager, didExit location: Location, name: String) {
        let event = Event.exit(areaName: name)
        locationRepository.addEvent(event)
        notificationsManager.sendLocalNotification(for: event)
    }
}
