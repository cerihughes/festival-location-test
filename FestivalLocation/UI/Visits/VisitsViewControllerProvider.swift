import Madog
import UIKit

class VisitsViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .addArea, let locationRepository, let locationManager else {
            return nil
        }
        let viewModel = VisitsViewModel(locationRepository: locationRepository, locationManager: locationManager)
        return VisitsViewController(viewModel: viewModel)
    }
}
