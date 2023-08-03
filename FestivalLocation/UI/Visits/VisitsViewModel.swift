import Foundation

protocol VisitsViewModelDelegate: AnyObject {
    func visitsViewModelDidUpdate(_ visitsViewModel: VisitsViewModel)
}

class VisitsViewModel {
    private let locationRepository: LocationRepository

    private var collectionNotificationToken: NSObject?

    weak var delegate: VisitsViewModelDelegate?

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
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
                delegate.visitsViewModelDidUpdate(self)
            default:
                break // No-op
            }
        }
    }
}
