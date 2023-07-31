import Foundation
import Madog

let serviceProviderName = "serviceProviderName"

protocol Services {
    var localDataSource: LocalDataSource { get }
    var locationManager: LocationManager { get }
}

class DefaultServices: ServiceProvider, Services {
    let name = serviceProviderName
    let localDataSource: LocalDataSource
    let locationManager: LocationManager

    // MARK: ServiceProvider
    required init(context: ServiceProviderCreationContext) {
        let localStorage = DefaultLocalStorage(persistentDataStore: UserDefaults.standard)
        localDataSource = DefaultLocalDataSource(localStorage: localStorage)
        locationManager = DefaultLocationManager()
    }
}

protocol ServicesProvider {
    var services: Services? { get }
}

extension ServicesProvider {
    var localDataSource: LocalDataSource? { services?.localDataSource }
    var locationManager: LocationManager? { services?.locationManager }
}
