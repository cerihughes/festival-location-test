import Madog
import UIKit

class FestivalDataViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .festivalData, let dataRepository, let lineupLoader else {
            return nil
        }
        let viewModel = FestivalDataViewModel(dataRepository: dataRepository, lineupLoader: lineupLoader)
        return FestivalDataViewController(context: context, viewModel: viewModel)
    }
}
