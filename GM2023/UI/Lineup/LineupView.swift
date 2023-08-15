import UIKit

class LineupView: UIView {
    let daySelection = UISegmentedControl(items: GMDay.allDisplayNames)
    let stageSelection = UISegmentedControl(items: GMStage.allDisplayNames)
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func enableStages(_ stages: [GMStage]) {
        let stageTitles = stages.map { $0.displayName }
        for index in 0 ..< stageSelection.numberOfSegments {
            guard let title = stageSelection.titleForSegment(at: index) else { continue }
            stageSelection.setEnabled(stageTitles.contains(title), forSegmentAt: index)
        }
    }

    private func commonInit() {
        backgroundColor = .white

        let font = UIFont.systemFont(ofSize: 16)
        daySelection.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        stageSelection.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        daySelection.apportionsSegmentWidthsByContent = true
        stageSelection.apportionsSegmentWidthsByContent = true

        daySelection.selectedSegmentIndex = GMDay.thursday.rawValue
        stageSelection.selectedSegmentIndex = GMStage.mountain.rawValue
        tableView.separatorStyle = .none
        tableView.bounces = false

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

extension GMStage {
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

extension GMDay {
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
