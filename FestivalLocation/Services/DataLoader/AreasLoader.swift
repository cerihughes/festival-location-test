import Foundation

protocol AreasLoader {
    func importAreas(data: Data) -> Bool
}

extension AreasLoader {
    func importAreas(loader: LocalDataLoader) -> Bool {
        guard let data = loader.loadData() else { return false }
        return importAreas(data: data)
    }

    @MainActor
    func importAreas(loader: RemoteDataLoader) async -> Bool {
        guard let data = await loader.loadData() else { return false }
        return importAreas(data: data)
    }
}

class DefaultAreasLoader: AreasLoader {
    let builder: AreasBuilder

    init(dataRepository: DataRepository) {
        builder = AreasBuilder(dataRepository: dataRepository)
    }

    func importAreas(data: Data) -> Bool {
        let decoder = JSONDecoder()
        guard let circularAreas: [CircularArea] = try? decoder.decode([CircularArea].self, from: data) else {
            return false
        }

        builder.persist(circularAreas: circularAreas)
        return true
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
