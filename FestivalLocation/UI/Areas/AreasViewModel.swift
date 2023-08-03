import Foundation

protocol AreasViewModelDelegate: AnyObject {
    func areasViewModelDidUpdate(_ areasViewModel: AreasViewModel)
}

class AreasViewModel {
    private let locationRepository: LocationRepository

    private var collectionNotificationToken: NSObject?

    private var areaNames = [String]() {
        didSet {
            guard areaNames != oldValue else { return }
            delegate?.areasViewModelDidUpdate(self)
        }
    }

    weak var delegate: AreasViewModelDelegate?

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
        self.locationRepository = locationRepository

        observe()
    }

    var numberOfAreas: Int {
        areaNames.count
    }

    func areaName(at index: Int) -> String? {
        areaNames[safe: index]
    }

    private func observe() {
        collectionNotificationToken = locationRepository.areas().observe { [weak self] changes in
            switch changes {
            case .initial(let areas), .update(let areas, _, _, _):
                self?.areaNames = areas.map { $0.name }
            default:
                break // No-op
            }
        }
    }
}
