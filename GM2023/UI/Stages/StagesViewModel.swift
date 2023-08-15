import Foundation
import MapKit

protocol StagesViewModelDelegate: AnyObject {
    func stagesViewModelDidUpdate(_ stagesViewModel: StagesViewModel)
}

class StagesViewModel {
    private let dataRepository: DataRepository
    private var collectionNotificationToken: NSObject?

    weak var delegate: StagesViewModelDelegate?

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
        observe()
    }

    var mapCircles: [MKCircle] {
        dataRepository.areas().map { $0.asCircularArea().asMapCircle() }
    }

    private func observe() {
        collectionNotificationToken = dataRepository.areas().observe { [weak self] changes in
            guard let self, let delegate else { return }
            switch changes {
            case .update:
                delegate.stagesViewModelDidUpdate(self)
            default:
                break // No-op
            }
        }
    }
}
