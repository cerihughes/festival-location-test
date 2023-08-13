import Foundation

protocol AreasViewModelDelegate: AnyObject {
    func areasViewModelDidUpdate(_ areasViewModel: AreasViewModel)
}

class AreasViewModel {
    private let dataRepository: DataRepository

    private var collectionNotificationToken: NSObject?

    private var areaNames = [String]() {
        didSet {
            guard areaNames != oldValue else { return }
            delegate?.areasViewModelDidUpdate(self)
        }
    }

    weak var delegate: AreasViewModelDelegate?

    init(dataRepository: DataRepository, locationManager: LocationManager) {
        self.dataRepository = dataRepository

        observe()
    }

    var numberOfAreas: Int {
        areaNames.count
    }

    func areaName(at index: Int) -> String? {
        areaNames[safe: index]
    }

    private func observe() {
        collectionNotificationToken = dataRepository.areas().observe { [weak self] changes in
            switch changes {
            case .initial(let areas), .update(let areas, _, _, _):
                self?.areaNames = areas.map { $0.name }
            default:
                break // No-op
            }
        }
    }
}
