import Madog
import UIKit

class AreasMapViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .areasMap, let locationRepository, let locationManager else {
            return nil
        }
        let viewModel = AreasMapViewModel(locationRepository: locationRepository, locationManager: locationManager)
        return AreasMapViewController(viewModel: viewModel)
    }
}
