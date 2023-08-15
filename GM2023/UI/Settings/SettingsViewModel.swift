import Foundation

class SettingsViewModel {
    private let dataRepository: DataRepository

    private var stageViewData = [ShowStageTableViewCell.ViewData]()

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository

        createStageViewData()
    }

    var numberOfStages: Int {
        stageViewData.count
    }

    func viewData(at index: Int) -> ShowStageTableViewCell.ViewData? {
        stageViewData[safe: index]
    }

    func updateStagePreference(at index: Int, value: Bool) {
        
    }

    private func createStageViewData() {
        stageViewData = GMStage.allCases.map {
            .init(name: $0.identifier, selected: true)
        }
    }
}
