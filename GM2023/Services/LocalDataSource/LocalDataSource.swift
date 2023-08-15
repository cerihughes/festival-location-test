import Foundation

protocol LocalDataSource {
    func isStageShowing(_ stageName: String) -> Bool
    func setStageShowing(_ stageName: String, showing: Bool)
    func setDefaultValues()
}

class DefaultLocalDataSource: LocalDataSource {
    private let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }

    func isStageShowing(_ stageName: String) -> Bool {
        localStorage.bool(forKey: isStageShowingKey(for: stageName))
    }

    func setStageShowing(_ stageName: String, showing: Bool) {
        localStorage.setBool(showing, forKey: isStageShowingKey(for: stageName))
    }

    func setDefaultValues() {
        setDefaultValue(true, for: .mountain)
        setDefaultValue(true, for: .farOut)
        setDefaultValue(true, for: .walledGarden)
        setDefaultValue(true, for: .rising)
        setDefaultValue(true, for: .chaiWallahs)
    }

    private func setDefaultValue(_ value: Bool, for stage: GMStage) {
        setStageShowing(stage.identifier, showing: value)
    }

    private func isStageShowingKey(for stageName: String) -> String {
        "settings.isStageShowing.\(stageName)"
    }
}
