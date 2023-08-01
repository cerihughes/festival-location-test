import Foundation

protocol AddAreaViewModelDelegate: AnyObject {
    func addAreaViewModel(_ addAreaViewModel: AddAreaViewModel, didAddArea area: Area)
    func addAreaViewModel(_ addAreaViewModel: AddAreaViewModel, didRemoveArea area: Area)
}

class AddAreaViewModel {
    private let locationRepository: LocationRepository
    private let locationManager: LocationManager

    private var collectionNotificationToken: NSObject?

    weak var delegate: AddAreaViewModelDelegate?

    init(locationRepository: LocationRepository, locationManager: LocationManager) {
        self.locationRepository = locationRepository
        self.locationManager = locationManager
        observe()
    }

    var areas: [Area] {
        locationRepository.areas().map { $0 }
    }

    private func observe() {
        collectionNotificationToken = locationRepository.areas().observe { [weak self] changes in
            guard let self, let delegate else { return }
            switch changes {
            case let .update(areas, _, insertions, deletions):
                insertions.forEach {
                    delegate.addAreaViewModel(self, didAddArea: areas[$0])
                }
                deletions.forEach {
                    delegate.addAreaViewModel(self, didRemoveArea: areas[$0])
                }
            default:
                break // No-op
            }
        }
    }

    func authoriseIfNeeded() {
        if locationManager.authorisationStatus != .accepted {
            locationManager.authorise()
        }
    }

    func createAreaAtCurrentLocation() async {
        guard let current = await locationManager.getLocation() else { return }
        Task { @MainActor in
            createArea(at: current)
        }
    }

    func createArea(at location: Location) {
        let area = Area.create(name: "Region", location: location)
        locationRepository.addArea(area)
    }
}
