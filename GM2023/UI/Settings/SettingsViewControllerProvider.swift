import Madog
import UIKit

class SettingsViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .settings,
            let localDataSource, let areasLoader, let lineupLoader, let locationManager, let notificationsManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }

        let viewModel = SettingsViewModel(
            localDataSource: localDataSource,
            areasLoader: areasLoader,
            lineupLoader: lineupLoader,
            locationManager: locationManager,
            notificationsManager: notificationsManager
        )
        let viewController = SettingsViewController(context: context, viewModel: viewModel)
        viewController.title = "Settings"
        viewController.tabBarItem = .init(title: "Settings", image: .init(named: "gear-7"), tag: 3)
        return viewController
    }
}
