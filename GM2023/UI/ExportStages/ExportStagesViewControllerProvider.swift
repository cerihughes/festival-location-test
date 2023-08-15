import Madog
import UIKit

class ExportStagesViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .exportStages, let dataRepository else { return nil }
        let viewModel = ExportStagesViewModel(dataRepository: dataRepository)
        return ExportStagesViewController(viewModel: viewModel)
    }
}
