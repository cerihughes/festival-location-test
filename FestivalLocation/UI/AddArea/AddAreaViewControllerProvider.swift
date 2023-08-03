import Madog
import UIKit

class AddAreaViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .addArea,
            let locationRepository,
            let locationManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = AddAreaViewModel(locationRepository: locationRepository, locationManager: locationManager)
        return AddAreaViewController(context: context, viewModel: viewModel)
    }
}
