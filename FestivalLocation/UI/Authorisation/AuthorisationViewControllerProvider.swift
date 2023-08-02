import Madog
import UIKit

class AuthorisationViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .authorisation, let locationManager, let notificationsManager else {
            return nil
        }
        let viewModel = AuthorisationViewModel(
            locationManager: locationManager,
            notificationsManager: notificationsManager
        )
        return AuthorisationViewController(context: context, viewModel: viewModel)
    }
}
