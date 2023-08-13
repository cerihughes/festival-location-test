import Madog
import UIKit

private let reuseIdentifier = "FestivalDataViewControllerIdentifier"

class FestivalDataViewController: UIViewController {
    private weak var context: AnyContext<Navigation>?
    private let viewModel: FestivalDataViewModel
    private let festivalDataView = FestivalDataView()

    init(context: AnyContext<Navigation>, viewModel: FestivalDataViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = festivalDataView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Line-up"

        festivalDataView.daySelection.addTarget(self, action: #selector(dayChanged), for: .valueChanged)
        festivalDataView.stageSelection.addTarget(self, action: #selector(stageChanged), for: .valueChanged)

        festivalDataView.tableView.register(FestivalSlotTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        festivalDataView.tableView.dataSource = self
        reloadData()
    }

    @objc private func dayChanged(_ segmentedControl: UISegmentedControl) {
        guard let day = FestivalDataView.Day(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.selectedDay = day
        reloadData()
    }

    @objc private func stageChanged(_ segmentedControl: UISegmentedControl) {
        guard let stage = FestivalDataView.Stage(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.selectedStage = stage
        reloadData()
    }

    private func reloadData() {
        festivalDataView.tableView.reloadData()
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

        cell.textLabel?.text = viewData.name
        cell.detailTextLabel?.text = viewData.time
        cell.textLabel?.textColor = viewData.timeStatus.colour
        return cell
    }
}
