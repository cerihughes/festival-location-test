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
        let viewController = FestivalDataViewController(context: context, viewModel: viewModel)
        viewController.title = "Lineup"
        viewController.tabBarItem = .init(title: "Lineup", image: .init(named: "grid-out-many-7"), tag: 0)
        return viewController
    }
}
