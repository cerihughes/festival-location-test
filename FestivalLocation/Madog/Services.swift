import Foundation
import Madog
import RealmSwift

let serviceProviderName = "serviceProviderName"

protocol Services {
    var locationRepository: LocationRepository { get }
    var locationManager: LocationManager { get }
    var notificationsManager: NotificationsManager { get }
    var locationMonitor: LocationMonitor { get }
}

class DefaultServices: ServiceProvider, Services {
    let name = serviceProviderName
    let locationRepository: LocationRepository
    let locationManager: LocationManager
    let notificationsManager: NotificationsManager
    let locationMonitor: LocationMonitor

    // MARK: ServiceProvider
    required init(context: ServiceProviderCreationContext) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }

        locationRepository = DefaultLocationRepository(realm: realm)
        locationManager = DefaultLocationManager()
        notificationsManager = DefaultNotificationsManager(notificationCenter: .current())
        locationMonitor = DefaultLocationMonitor(
            locationManager: locationManager,
            locationRepository: locationRepository,
            notificationsManager: notificationsManager
        )
    }
}

protocol ServicesProvider {
    var services: Services? { get }
}

extension ServicesProvider {
    var locationRepository: LocationRepository? { services?.locationRepository }
    var locationManager: LocationManager? { services?.locationManager }
    var notificationsManager: NotificationsManager? { services?.notificationsManager }
}
