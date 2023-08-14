import Foundation
import Madog
import RealmSwift

let serviceProviderName = "serviceProviderName"

protocol Services {
    var dataRepository: DataRepository { get }
    var lineupLoader: LineupLoader { get }
    var areasLoader: AreasLoader { get }
    var locationManager: LocationManager { get }
    var notificationsManager: NotificationsManager { get }
    var locationMonitor: LocationMonitor { get }
}

class DefaultServices: ServiceProvider, Services {
    let name = serviceProviderName
    let dataRepository: DataRepository
    let lineupLoader: LineupLoader
    let areasLoader: AreasLoader
    let locationManager: LocationManager
    let notificationsManager: NotificationsManager
    let locationMonitor: LocationMonitor

    // MARK: ServiceProvider
    required init(context: ServiceProviderCreationContext) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }

        dataRepository = RealmDataRepository(realm: realm)
        lineupLoader = DefaultLineupLoader(source: .remote(.greenMan2023FestivalLineup), dataRepository: dataRepository)
        areasLoader = DefaultAreasLoader(source: .remote(.greenMan2023FestivalAreas), dataRepository: dataRepository)
        locationManager = DefaultLocationManager()
        notificationsManager = DefaultNotificationsManager(
            dataRepository: dataRepository,
            notificationCenter: .current(),
            timeFormatter: .HH_mm()
        )
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
    var areasLoader: AreasLoader? { services?.areasLoader }
    var locationManager: LocationManager? { services?.locationManager }
    var notificationsManager: NotificationsManager? { services?.notificationsManager }
    var locationMonitor: LocationMonitor? { services?.locationMonitor }
}
