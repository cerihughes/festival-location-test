import Foundation
import Madog

let serviceProviderName = "serviceProviderName"

protocol Services {
}

class DefaultServices: ServiceProvider, Services {
    let name = serviceProviderName

    // MARK: ServiceProvider
    required init(context: ServiceProviderCreationContext) {
    }
}

protocol ServicesProvider {
    var services: Services? { get }
}

extension ServicesProvider {
}
