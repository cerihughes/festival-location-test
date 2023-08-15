import Madog
import UIKit

class AddStageViewControllerProvider: DefaultViewControllerProvider {
    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard
            token == .addStage,
            let dataRepository,
            let locationManager,
            let context = context as? AnyForwardBackNavigationContext<Navigation>
        else {
            return nil
        }
        let viewModel = AddStageViewModel(dataRepository: dataRepository, locationManager: locationManager)
        return AddStageViewController(context: context, viewModel: viewModel)
    }
}
