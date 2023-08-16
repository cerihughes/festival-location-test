import Foundation

class ExportStagesViewModel {
    private let dataRepository: DataRepository

    private let encoder = JSONEncoder()

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository

        encoder.outputFormatting = .prettyPrinted
    }

    var areasJSONString: String? {
        guard let data = try? encoder.encode(circularAreas()) else { return nil }
        return .init(data: data, encoding: .utf8)
    }

    func deleteAllStages() {
        for area in dataRepository.areas() {
            dataRepository.delete(area)
        }
    }

    private func circularAreas() -> [CircularArea] {
        dataRepository.areas().map { $0.asCircularArea() }
    }
}
