import UIKit

class FestivalDataView: UIView {
    enum Day: CaseIterable {
        case thursday, friday, saturday, sunday
    }
    enum Stage: CaseIterable {
        case mountain, farOut, walledGarden, rising, chaiWallahs, roundTheTwist
    }

    let daySelection = UISegmentedControl(items: Day.allDisplayNames)
    let stageSelection = UISegmentedControl(items: Stage.allDisplayNames)
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        daySelection.selectedSegmentIndex = 0
        stageSelection.selectedSegmentIndex = 0

        addSubviews(daySelection, stageSelection, tableView)

        daySelection.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }

        stageSelection.snp.makeConstraints { make in
            make.top.equalTo(daySelection.snp.bottom).offset(16)
            make.leading.trailing.equalTo(daySelection)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(stageSelection.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension FestivalDataView.Stage {
    static var allDisplayNames: [String] {
        allCases.map { $0.displayName }
    }

    var displayName: String {
        switch self {
        case .mountain:
            return "Mountain"
        case .farOut:
            return "Far Out"
        case .walledGarden:
            return "Walled"
        case .rising:
            return "Rising"
        case .chaiWallahs:
            return "Chai"
        case .roundTheTwist:
            return "Twist"
        }
    }
}

extension FestivalDataView.Day {
    static var allDisplayNames: [String] {
        allCases.map { $0.displayName }
    }

    var displayName: String {
        switch self {
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}
