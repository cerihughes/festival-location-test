import Madog
import UIKit

class SettingsViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .settings, let dataRepository else { return nil }
        let viewModel = SettingsViewModel(dataRepository: dataRepository)
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.title = "Settings"
        viewController.tabBarItem = .init(title: "Settings", image: .init(named: "gear-7"), tag: 3)
        return viewController
    }
}
