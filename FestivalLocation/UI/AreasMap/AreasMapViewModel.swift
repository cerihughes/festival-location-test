import Foundation

protocol AreasMapViewModelDelegate: AnyObject {
    func areasMapViewModelDidUpdate(_ areasMapViewModel: AreasMapViewModel)
}

class AreasMapViewModel {
    private let dataRepository: DataRepository
    private var collectionNotificationToken: NSObject?

    weak var delegate: AreasMapViewModelDelegate?

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
        observe()
    }

    var areas: [Area] {
        dataRepository.areas().map { $0 }
    }

    private func observe() {
        collectionNotificationToken = dataRepository.areas().observe { [weak self] changes in
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
