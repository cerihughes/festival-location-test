import UIKit

private let reuseIdentifier = "HistoryViewControllerIdentifier"

class HistoryViewController: TypedViewController<HistoryView> {
    private let viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typedView.tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        typedView.tableView.dataSource = self
        typedView.tableView.reloadData()

        viewModel.delegate = self
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? HistoryTableViewCell, let viewData = viewModel.viewData(at: indexPath.row) else {
            return cell
        }

        cell.configure(with: viewData)
        return cell
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func historyViewModelDidUpdate(_ historyViewModel: HistoryViewModel) {
        typedView.tableView.reloadData()
    }
}
