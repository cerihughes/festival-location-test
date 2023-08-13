import Madog
import UIKit

private let reuseIdentifier = "AreasViewControllerIdentifier"

class AreasViewController: TypedViewController<AreasView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AreasViewModel

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: AreasViewModel) {
        self.context = context
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
        typedView.tableView.delegate = self
        typedView.tableView.reloadData()

        viewModel.delegate = self
    }
}

extension AreasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfAreas
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let areaName = viewModel.areaName(at: indexPath.row) {
            cell.textLabel?.text = areaName
        }
        return cell
    }
}

extension AreasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let areaName = viewModel.areaName(at: indexPath.row) else { return }
        context?.navigateForward(token: .visits(areaName), animated: true)
    }
}

extension AreasViewController: AreasViewModelDelegate {
    func areasViewModelDidUpdate(_ areasViewModel: AreasViewModel) {
        typedView.tableView.reloadData()
    }
}
