import Madog
import UIKit

class HistoriesViewControllerProvider: DefaultViewControllerProvider {
    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .histories,
            let dataRepository,
            let locationManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = HistoriesViewModel(dataRepository: dataRepository, locationManager: locationManager)
        let viewController = HistoriesViewController(context: context, viewModel: viewModel)
        viewController.title = "History"
        viewController.tabBarItem = .init(title: "History", image: .init(named: "text-list-7"), tag: 2)
        return viewController
    }
}
