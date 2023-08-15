import Madog
import UIKit

class HistoryViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard case let .history(areaName) = token, let dataRepository, let locationManager else {
            return nil
        }
        let viewModel = HistoryViewModel(
            areaName: areaName,
            dataRepository: dataRepository,
            locationManager: locationManager
        )
        let viewController = HistoryViewController(viewModel: viewModel)
        viewController.title = areaName
        return viewController
    }
}
