import Foundation

protocol LocalDataSource {
    func isStageShowing(_ stage: GMStage) -> Bool
    func setStageShowing(_ stage: GMStage, showing: Bool)
}

class DefaultLocalDataSource: LocalDataSource {
    private let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }

    func isStageShowing(_ stage: GMStage) -> Bool {
        localStorage.bool(forKey: isStageShowingKey(for: stage.identifier))
    }

    func setStageShowing(_ stage: GMStage, showing: Bool) {
        localStorage.setBool(showing, forKey: isStageShowingKey(for: stage.identifier))
    }

    private func isStageShowingKey(for stageName: String) -> String {
        "settings.isStageShowing.\(stageName)"
    }
}
