import Foundation

class AreasExportViewModel {
    private let dataRepository: DataRepository
    private let areasLoader: AreasLoader

    private let encoder = JSONEncoder()

    weak var delegate: AreasMapViewModelDelegate?

    init(dataRepository: DataRepository, areasLoader: AreasLoader) {
        self.dataRepository = dataRepository
        self.areasLoader = areasLoader

        encoder.outputFormatting = .prettyPrinted
    }

    var jsonString: String? {
        guard let data = try? encoder.encode(circularAreas()) else { return nil }
        return .init(data: data, encoding: .utf8)
    }

    @discardableResult
    func importAreas() async -> Bool {
        await areasLoader.importAreas(loader: .url(.greenMan2023FestivalAreas))
    }

    private func circularAreas() -> [CircularArea] {
        dataRepository.areas().map { $0.asCircularArea() }
    }
}
