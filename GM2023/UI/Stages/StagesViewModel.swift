import Foundation
import MapKit

protocol StagesViewModelDelegate: AnyObject {
    func stagesViewModelDidUpdate(_ stagesViewModel: StagesViewModel)
}

class StagesViewModel {
    private let dataRepository: DataRepository
    private let timeFormatter: DateFormatter

    private var collectionNotificationToken: NSObject?

    weak var delegate: StagesViewModelDelegate?

    init(dataRepository: DataRepository, timeFormatter: DateFormatter) {
        self.dataRepository = dataRepository
        self.timeFormatter = timeFormatter
        observe()
    }

    var mapCircles: [MKCircle] {
        dataRepository.areas()
            .map { $0.asMapCircle() }
            .map { annotatingWithNowNext(circle: $0)}
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

    private func annotatingWithNowNext(circle: MKCircle) -> MKCircle {
        if let title = circle.title, let nowNext = dataRepository.nowNext(for: title) {
            circle.title = "\(title)\n(\(nowNext.now.name))"
        }
        return circle
    }
}
