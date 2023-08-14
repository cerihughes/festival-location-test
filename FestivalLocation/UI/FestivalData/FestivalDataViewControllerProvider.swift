import Madog
import UIKit

class FestivalDataViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .festivalData, let dataRepository, let locationMonitor, let lineupLoader else {
            return nil
        }
        let viewModel = FestivalDataViewModel(
            dataRepository: dataRepository,
            locationMonitor: locationMonitor,
            lineupLoader: lineupLoader
        )
        return FestivalDataViewController(context: context, viewModel: viewModel)
    }
}
