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
        let viewController = AreasMapViewController(context: context, viewModel: viewModel)
        viewController.title = "Stages"
        viewController.tabBarItem = .init(title: "Stages", image: .init(named: "pin-map-7"), tag: 1)
        return viewController
    }
}
