import Madog
import UIKit

class FestivalDataViewControllerProvider: DefaultViewControllerProvider {

    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .festivalData, let locationManager, let notificationsManager else {
            return nil
        }
        let viewModel = FestivalDataViewModel()
        return FestivalDataViewController(context: context, viewModel: viewModel)
    }
}
