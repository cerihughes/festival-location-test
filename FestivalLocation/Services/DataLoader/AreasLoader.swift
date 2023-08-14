import Foundation

protocol AreasLoader {
    func importAreas() -> Bool
}

class DefaultAreasLoader: AreasLoader {
    private let source: DataLoaderSource
    let builder: AreasBuilder

    init(source: DataLoaderSource, dataRepository: DataRepository) {
        self.source = source
        builder = AreasBuilder(dataRepository: dataRepository)
    }

    func importAreas() -> Bool {
        let decoder = JSONDecoder()
        guard
            let data = source.loadData(),
            let circularAreas: [CircularArea] = try? decoder.decode([CircularArea].self, from: data)
        else { return false }

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
