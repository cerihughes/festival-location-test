import Madog
import UIKit

class FestivalDataViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .festivalData, let dataRepository else {
            return nil
        }
        let viewModel = FestivalDataViewModel(dataRepository: dataRepository)
        return FestivalDataViewController(context: context, viewModel: viewModel)
    }
}
