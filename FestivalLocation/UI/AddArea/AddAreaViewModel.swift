import Foundation

protocol AddAreaViewModelDelegate: AnyObject {
    func areasMapViewModel(_ areasMapViewModel: AddAreaViewModel, didAddArea area: Area)
    func areasMapViewModel(_ areasMapViewModel: AddAreaViewModel, didRemoveArea area: Area)
}

class AddAreaViewModel {
    private let locationRepository: LocationRepository
    private let locationManager: LocationManager

    private var collectionNotificationToken: NSObject?
    private var counter = 1

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
                    delegate.areasMapViewModel(self, didAddArea: areas[$0])
                }
                deletions.forEach {
                    delegate.areasMapViewModel(self, didRemoveArea: areas[$0])
                }
            default:
                break // No-op
            }
        }
    }

    func createAreaAtCurrentLocation() async {
        guard let current = await locationManager.getLocation() else { return }
        Task { @MainActor in
            createArea(at: current)
        }
    }

    func createArea(at location: Location) {
        let area = Area.create(name: "Region \(counter)", location: location)
        locationRepository.addArea(area)
        counter += 1
    }
}
