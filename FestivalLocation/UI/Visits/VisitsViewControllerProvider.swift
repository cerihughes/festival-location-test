import Madog
import UIKit

class VisitsViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard case let .visits(areaName) = token, let locationRepository, let locationManager else {
            return nil
        }
        let viewModel = VisitsViewModel(
            areaName: areaName,
            locationRepository: locationRepository,
            locationManager: locationManager
        )
        return VisitsViewController(viewModel: viewModel)
    }
}
