import Madog
import UIKit

class AddAreaViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .addArea, let locationRepository, let locationManager, let notificationsManager else {
            return nil
        }
        let viewModel = AddAreaViewModel(
            locationRepository: locationRepository,
            locationManager: locationManager,
            notificationsManager: notificationsManager
        )
        return AddAreaViewController(viewModel: viewModel)
    }
}
