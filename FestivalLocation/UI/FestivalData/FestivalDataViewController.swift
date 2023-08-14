import Madog
import UIKit

private let reuseIdentifier = "FestivalDataViewControllerIdentifier"

class FestivalDataViewController: TypedViewController<FestivalDataView> {
    private weak var context: AnyContext<Navigation>?
    private let viewModel: FestivalDataViewModel

    init(context: AnyContext<Navigation>, viewModel: FestivalDataViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typedView.daySelection.addTarget(self, action: #selector(dayChanged), for: .valueChanged)
        typedView.stageSelection.addTarget(self, action: #selector(stageChanged), for: .valueChanged)

        typedView.tableView.register(FestivalSlotTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        typedView.tableView.dataSource = self

        typedView.daySelection.selectedSegmentIndex = viewModel.indexOfSelectedDay
        updateStages()
        reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.updateForLocalStage() {
            updateStages()
            reloadData()
        }
    }

    @objc private func dayChanged(_ segmentedControl: UISegmentedControl) {
        guard let day = GMDay(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.selectedDay = day
        updateStages()
        reloadData()
    }

    @objc private func stageChanged(_ segmentedControl: UISegmentedControl) {
        guard let stage = GMStage.allCases[safe: segmentedControl.selectedSegmentIndex] else { return }
        viewModel.selectedStage = stage
        reloadData()
    }

    private func updateStages() {
        typedView.enableStages(viewModel.stagesForSelectedDay)
        typedView.stageSelection.selectedSegmentIndex = viewModel.indexOfSelectedStage
    }

    private func reloadData() {
        typedView.tableView.reloadData()
        if let index = viewModel.indexToScrollTo {
            typedView.tableView.scrollToRow(at: .init(row: index, section: 0), at: .middle, animated: true)
        }
    }
}

extension FestivalDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSlots
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard
            let cell = cell as? FestivalSlotTableViewCell,
            let viewData = viewModel.viewData(at: indexPath.row)
        else {
            return cell
        }

        cell.configure(with: viewData)
        return cell
    }
}
