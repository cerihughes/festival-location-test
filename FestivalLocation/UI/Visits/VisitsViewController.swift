import UIKit

private let reuseIdentifier = "VisitsViewControllerIdentifier"

class VisitsViewController: TypedViewController<VisitsView> {
    private let viewModel: VisitsViewModel

    init(viewModel: VisitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Visits"

        typedView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        typedView.tableView.dataSource = self
        typedView.tableView.reloadData()

        viewModel.delegate = self
    }
}

extension VisitsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfVisits
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let visit = viewModel.visit(at: indexPath.row) {
            cell.textLabel?.text = visit.title
        }
        return cell
    }
}

extension VisitsViewController: VisitsViewModelDelegate {
    func visitsViewModelDidUpdate(_ visitsViewModel: VisitsViewModel) {
        typedView.tableView.reloadData()
    }
}
