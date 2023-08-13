import Madog
import UIKit

class AddAreaViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .addArea,
            let dataRepository,
            let locationManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = AddAreaViewModel(dataRepository: dataRepository, locationManager: locationManager)
        return AddAreaViewController(context: context, viewModel: viewModel)
    }
}
