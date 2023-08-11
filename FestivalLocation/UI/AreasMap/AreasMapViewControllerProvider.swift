import Madog
import UIKit

class AreasMapViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .areasMap,
            let dataRepository,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = AreasMapViewModel(dataRepository: dataRepository)
        return AreasMapViewController(context: context, viewModel: viewModel)
    }
}
