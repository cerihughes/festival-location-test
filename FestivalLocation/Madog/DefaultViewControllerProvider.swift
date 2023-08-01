import Madog
import UIKit

class DefaultViewControllerProvider: ViewControllerProvider, ServicesProvider {
    var services: Services?

    // MARK: ViewControllerProvider

    final func configure(with serviceProviders: [String: ServiceProvider]) {
        services = serviceProviders[serviceProviderName] as? Services
    }

    func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        nil // OVERRIDE
    }
}
