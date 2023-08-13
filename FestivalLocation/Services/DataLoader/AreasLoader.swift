import Foundation

protocol AreasLoader {
    var builder: AreasBuilder { get }
    func fetchData() -> Data?
}

extension String {
    static let greenMan2023FestivalAreas = "GreenMan2023-Areas.json"
}

extension AreasLoader {
    func importAreas() -> Bool {
        let decoder = JSONDecoder()
        guard
            let data = fetchData(),
            let circularAreas: [CircularArea] = try? decoder.decode([CircularArea].self, from: data)
        else { return false }

        builder.persist(circularAreas: circularAreas)
        return true
    }
}

class FileAreasLoader: AreasLoader {
    private let fileName: String
    let builder: AreasBuilder

    init(fileName: String, dataRepository: DataRepository) {
        self.fileName = fileName
        builder = AreasBuilder(dataRepository: dataRepository)
    }

    func fetchData() -> Data? {
        guard
            let path = Bundle.main.path(for: fileName),
            let contents = try? String(contentsOfFile: path)
        else { return nil }

        return contents.data(using: .utf8)
    }
}

class AreasBuilder {
    private let dataRepository: DataRepository

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }

    func persist(circularAreas: [CircularArea]) {
        for circularArea in circularAreas {
            if let existing = dataRepository.area(name: circularArea.name) {
                dataRepository.commit {
                    existing.latitude = circularArea.location.latitude
                    existing.longitude = circularArea.location.longitude
                    existing.radius = circularArea.radius
                }
            } else {
                let area = Area.create(circularArea: circularArea)
                dataRepository.add(area)
            }
        }
    }
}
