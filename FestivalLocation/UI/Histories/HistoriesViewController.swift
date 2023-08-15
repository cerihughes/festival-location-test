import Madog
import UIKit

private let reuseIdentifier = "HistoriesViewControllerIdentifier"

class HistoriesViewController: TypedViewController<HistoriesView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: HistoriesViewModel

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: HistoriesViewModel) {
        self.context = context
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
        typedView.tableView.delegate = self
        typedView.tableView.reloadData()

        viewModel.delegate = self
    }
}

extension HistoriesViewController: UITableViewDataSource {
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

extension HistoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let token = viewModel.navigationToken(at: indexPath.row) else { return }
        context?.navigateForward(token: token, animated: true)
    }
}

extension HistoriesViewController: HistoriesViewModelDelegate {
    func historiesViewModelDidUpdate(_ historiesViewModel: HistoriesViewModel) {
        typedView.tableView.reloadData()
    }
}
