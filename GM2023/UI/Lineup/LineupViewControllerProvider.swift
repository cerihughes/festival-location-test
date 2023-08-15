import Madog
import UIKit

class LineupViewControllerProvider: DefaultViewControllerProvider {
    override func createViewController(token: Navigation, context: AnyContext<Navigation>) -> ViewController? {
        guard token == .lineup, let localDataSource, let dataRepository, let locationMonitor else {
            return nil
        }
        let viewModel = LineupViewModel(
            localDataSource: localDataSource,
            dataRepository: dataRepository,
            locationMonitor: locationMonitor
        )
        let viewController = LineupViewController(context: context, viewModel: viewModel)
        viewController.title = "Lineup"
        viewController.tabBarItem = .init(title: "Lineup", image: .init(named: "grid-out-many-7"), tag: 0)
        return viewController
    }
}
