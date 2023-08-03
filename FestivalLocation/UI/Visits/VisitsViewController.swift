import UIKit

private let reuseIdentifier = "VisitsViewControllerIdentifier"

class VisitsViewController: UIViewController {
    private let viewModel: VisitsViewModel
    private let visitsView = VisitsView()

    init(viewModel: VisitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = visitsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Visits"

        visitsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        visitsView.tableView.dataSource = self
        visitsView.tableView.reloadData()

        viewModel.delegate = self
    }
}

extension VisitsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfAreas
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.title(at: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfVisits(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let visit = viewModel.visit(at: indexPath) {
            cell.textLabel?.text = visit.title
        }
        return cell
    }
}

extension VisitsViewController: VisitsViewModelDelegate {
    func visitsViewModelDidUpdate(_ visitsViewModel: VisitsViewModel) {
        visitsView.tableView.reloadData()
    }
}

private extension VisitsViewModel {
    func visit(at indexPath: IndexPath) -> VisitViewData? {
        visit(areaIndex: indexPath.section, visitIndex: indexPath.row)
    }
}
