import Foundation

class SettingsViewModel {
    private let localDataSource: LocalDataSource
    private let areasLoader: AreasLoader
    private let lineupLoader: LineupLoader

    private var stageViewData = [ShowStageTableViewCell.ViewData]()

    init(localDataSource: LocalDataSource, areasLoader: AreasLoader, lineupLoader: LineupLoader) {
        self.localDataSource = localDataSource
        self.areasLoader = areasLoader
        self.lineupLoader = lineupLoader

        createStageViewData()
    }

    func reloadData() async {
        _ = await areasLoader.importAreas(loader: .url(.greenMan2023FestivalAreas))
        _ = await lineupLoader.importLineup(loader: .url(.greenMan2023FestivalLineup))
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
