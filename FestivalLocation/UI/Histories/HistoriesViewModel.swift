import Foundation

protocol HistoriesViewModelDelegate: AnyObject {
    func historiesViewModelDidUpdate(_ historiesViewModel: HistoriesViewModel)
}

class HistoriesViewModel {
    private let dataRepository: DataRepository

    private var collectionNotificationToken: NSObject?

    private var viewData = [HistoryTableViewCell.ViewData]() {
        didSet {
            delegate?.historiesViewModelDidUpdate(self)
        }
    }

    weak var delegate: HistoriesViewModelDelegate?

    init(dataRepository: DataRepository, locationManager: LocationManager) {
        self.dataRepository = dataRepository

        observe()
    }

    var numberOfItems: Int {
        viewData.count
    }

    func viewData(at index: Int) -> HistoryTableViewCell.ViewData? {
        viewData[safe: index]
    }

    func navigationToken(at index: Int) -> Navigation? {
        guard let viewData = viewData(at: index) else { return nil }
        return .history(viewData.name)
    }

    private func observe() {
        collectionNotificationToken = dataRepository.areas().observe { [weak self] changes in
            switch changes {
            case .initial(let areas), .update(let areas, _, _, _):
                self?.viewData = areas.enumerated().map { .init(isEven: $0.offset.isEven, name: $0.element.name) }
            default:
                break // No-op
            }
        }
    }
}
