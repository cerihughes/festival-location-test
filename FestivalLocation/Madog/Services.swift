import Foundation
import Madog
import RealmSwift

let serviceProviderName = "serviceProviderName"

protocol Services {
    var dataRepository: DataRepository { get }
    var lineupLoader: LineupLoader { get }
    var locationManager: LocationManager { get }
    var notificationsManager: NotificationsManager { get }
    var locationMonitor: LocationMonitor { get }
}

class DefaultServices: ServiceProvider, Services {
    let name = serviceProviderName
    let dataRepository: DataRepository
    let lineupLoader: LineupLoader
    let locationManager: LocationManager
    let notificationsManager: NotificationsManager
    let locationMonitor: LocationMonitor

    // MARK: ServiceProvider
    required init(context: ServiceProviderCreationContext) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }

        dataRepository = RealmDataRepository(realm: realm)
        lineupLoader = FileLineupLoader(fileName: .greenMan2023FestivalLineup, dataRepository: dataRepository)
        locationManager = DefaultLocationManager()
        notificationsManager = DefaultNotificationsManager(notificationCenter: .current(), dateFormatter: .create())
        locationMonitor = DefaultLocationMonitor(
            locationManager: locationManager,
            dataRepository: dataRepository,
            notificationsManager: notificationsManager
        )
    }
}

protocol ServicesProvider {
    var services: Services? { get }
}

extension ServicesProvider {
    var dataRepository: DataRepository? { services?.dataRepository }
    var lineupLoader: LineupLoader? { services?.lineupLoader }
    var locationManager: LocationManager? { services?.locationManager }
    var notificationsManager: NotificationsManager? { services?.notificationsManager }
}
