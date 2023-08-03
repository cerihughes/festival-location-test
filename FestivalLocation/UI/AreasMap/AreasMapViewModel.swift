import Foundation

protocol AreasMapViewModelDelegate: AnyObject {
    func areasMapViewModelDidUpdate(_ areasMapViewModel: AreasMapViewModel)
}

class AreasMapViewModel {
    private let locationRepository: LocationRepository
    private var collectionNotificationToken: NSObject?

    weak var delegate: AreasMapViewModelDelegate?

    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
        observe()
    }

    var areas: [Area] {
        locationRepository.areas().map { $0 }
    }

    private func observe() {
        collectionNotificationToken = locationRepository.areas().observe { [weak self] changes in
            guard let self, let delegate else { return }
            switch changes {
            case .update:
                delegate.areasMapViewModelDidUpdate(self)
            default:
                break // No-op
            }
        }
    }
}
