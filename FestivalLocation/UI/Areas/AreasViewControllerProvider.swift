import Madog
import UIKit

class AreasViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .areas,
            let dataRepository,
            let locationManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = AreasViewModel(dataRepository: dataRepository, locationManager: locationManager)
        return AreasViewController(context: context, viewModel: viewModel)
    }
}
