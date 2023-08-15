import Foundation

class SettingsViewModel {
    private let localDataSource: LocalDataSource

    private var stageViewData = [ShowStageTableViewCell.ViewData]()

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource

        createStageViewData()
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
