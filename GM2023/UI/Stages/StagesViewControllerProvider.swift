import Madog
import UIKit

class StagesViewControllerProvider: DefaultViewControllerProvider {
    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .stages,
            let dataRepository,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = StagesViewModel(dataRepository: dataRepository, timeFormatter: .HH_mm())
        let viewController = StagesViewController(context: context, viewModel: viewModel)
        viewController.title = "Stages"
        viewController.tabBarItem = .init(title: "Stages", image: .init(named: "pin-map-7"), tag: 1)
        return viewController
    }
}
