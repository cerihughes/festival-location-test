import Madog
import UIKit

class ReloadDataViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .reloadData, let dataRepository, let areasLoader else { return nil }
        let viewModel = ReloadDataViewModel(dataRepository: dataRepository, areasLoader: areasLoader)
        return ReloadDataViewController(viewModel: viewModel)
    }
}
