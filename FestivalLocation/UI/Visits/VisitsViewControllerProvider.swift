import Madog
import UIKit

class VisitsViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard case let .visits(areaName) = token, let dataRepository, let locationManager else {
            return nil
        }
        let viewModel = VisitsViewModel(
            areaName: areaName,
            dataRepository: dataRepository,
            locationManager: locationManager
        )
        return VisitsViewController(viewModel: viewModel)
    }
}
