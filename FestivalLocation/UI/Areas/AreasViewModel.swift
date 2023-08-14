import Foundation

protocol AreasViewModelDelegate: AnyObject {
    func areasViewModelDidUpdate(_ areasViewModel: AreasViewModel)
}

class AreasViewModel {
    private let dataRepository: DataRepository

    private var collectionNotificationToken: NSObject?

    private var areaNames = [AreasTableViewCell.ViewData]() {
        didSet {
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

    func viewData(at index: Int) -> AreasTableViewCell.ViewData? {
        areaNames[safe: index]
    }

    func navigationToken(at index: Int) -> Navigation? {
        guard let viewData = viewData(at: index) else { return nil }
        return .visits(viewData.name)
    }

    private func observe() {
        collectionNotificationToken = dataRepository.areas().observe { [weak self] changes in
            switch changes {
            case .initial(let areas), .update(let areas, _, _, _):
                self?.areaNames = areas.enumerated().map { .init(isEven: $0.offset.isEven, name: $0.element.name) }
            default:
                break // No-op
            }
        }
    }
}
