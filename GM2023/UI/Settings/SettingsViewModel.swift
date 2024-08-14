import Foundation

class SettingsViewModel {
    private let localDataSource: LocalDataSource
    private let areasLoader: AreasLoader
    private let lineupLoader: LineupLoader
    private let locationManager: LocationManager
    private let notificationsManager: NotificationsManager

    private var stageViewData = [ShowStageTableViewCell.ViewData]()

    init(
        localDataSource: LocalDataSource,
        areasLoader: AreasLoader,
        lineupLoader: LineupLoader,
        locationManager: LocationManager,
        notificationsManager: NotificationsManager
    ) {
        self.localDataSource = localDataSource
        self.areasLoader = areasLoader
        self.lineupLoader = lineupLoader
        self.locationManager = locationManager
        self.notificationsManager = notificationsManager

        locationManager.authorisationDelegate = self
        createStageViewData()
    }

    func reloadData() async {
        _ = await areasLoader.importAreas(loader: .url(.greenMan2024FestivalAreas))
        _ = await lineupLoader.importLineup(loader: .url(.greenMan2024FestivalLineup))
    }

    func authoriseLocation() {
        locationManager.requestWhenInUseAuthorisation()
    }

    func authoriseForNotifications() async -> Bool {
        await notificationsManager.authorise()
    }

    var numberOfStages: Int {
        stageViewData.count
    }

    func viewData(at index: Int) -> ShowStageTableViewCell.ViewData? {
        stageViewData[safe: index]
    }

    func updateStagePreference(at index: Int, value: Bool) {
        guard let stage = GMStage.allCases[safe: index] else { return }
        localDataSource.setStageShowing(stage, showing: value)
    }

    private func createStageViewData() {
        stageViewData = GMStage.allCases.map {
            .init(name: $0.identifier, selected: localDataSource.isStageShowing($0))
        }
    }
}

extension SettingsViewModel: LocationManagerAuthorisationDelegate {
    func locationManager(
        _ locationManager: LocationManager,
        didChangeAuthorisation authorisation: LocationAuthorisation
    ) {
        if authorisation == .whenInUse {
            locationManager.requestAlwaysAuthorisation()
        }
    }
}
