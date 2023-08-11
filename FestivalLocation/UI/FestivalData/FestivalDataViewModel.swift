import Foundation

class FestivalDataViewModel {
    private let dataRepository: DataRepository

    private var slots = [FestivalSlotTableViewCell.ViewData]()

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
        updateSlots()
    }

    var selectedDay: FestivalDataView.Day = .thursday {
        didSet {
            updateSlots()
        }
    }

    var selectedStage: FestivalDataView.Stage = .mountain {
        didSet {
            updateSlots()
        }
    }

    var numberOfSlots: Int {
        slots.count
    }

    func viewData(at index: Int) -> FestivalSlotTableViewCell.ViewData? {
        slots[safe: index]
    }

    private func updateSlots() {
        slots = [
            .init(name: "Hello", time: "12:00 - 13:00", timeStatus: .past, visited: false),
            .init(name: "There", time: "13:30 - 14:45", timeStatus: .pending, visited: false),
            .init(name: "BCNR", time: "15:15 - 16:40", timeStatus: .future, visited: false)
        ]
    }
}

private extension FestivalDataView.Stage {
    var identifier: String {
        switch self {
        case .mountain:
            return "Mountain Stage"
        case .farOut:
            return "Far Out"
        case .walledGarden:
            return "Walled Garden"
        case .rising:
            return "Rising"
        case .chaiWallahs:
            return "Chai Wallahs"
        case .roundTheTwist:
            return "Round The Twist"
        }
    }
}
