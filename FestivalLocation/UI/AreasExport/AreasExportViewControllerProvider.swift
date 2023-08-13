import Madog
import UIKit

class AreasExportViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .areasExport, let dataRepository, let areasLoader else { return nil }
        let viewModel = AreasExportViewModel(dataRepository: dataRepository, areasLoader: areasLoader)
        return AreasExportViewController(viewModel: viewModel)
    }
}
