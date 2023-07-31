import Madog
import UIKit

class AreasViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .areas else { return nil }
        let viewModel = AreasViewModel()
        return AreasViewController(viewModel: viewModel)
    }
}
