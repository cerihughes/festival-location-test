import Madog
import UIKit

private let reuseIdentifier = "SettingsViewControllerIdentifier"

class SettingsViewController: TypedViewController<SettingsView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: SettingsViewModel

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: SettingsViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typedView.reloadDataButton.addTarget(self, action: #selector(reloadDataTapped), for: .touchUpInside)
        typedView.showStagesJSONButton.addTarget(self, action: #selector(showStagesJSON), for: .touchUpInside)

        typedView.stageTableView.register(ShowStageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        typedView.stageTableView.dataSource = self
        typedView.stageTableView.reloadData()
    }

    @objc private func reloadDataTapped(_ item: UIButton) {
        Task {
            await viewModel.reloadData()
        }
    }

    @objc private func showStagesJSON(_ item: UIButton) {
        context?.navigateForward(token: .reloadData, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfStages
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? ShowStageTableViewCell, let viewData = viewModel.viewData(at: indexPath.row) else {
            return cell
        }

        cell.delegate = self
        cell.configure(with: viewData)
        return cell
    }
}

extension SettingsViewController: ShowStageTableViewCellDelegate {
    func showStageTableViewCell(_ showStageTableViewCell: ShowStageTableViewCell, didToggleTo value: Bool) {
        guard let indexPath = typedView.stageTableView.indexPath(for: showStageTableViewCell) else { return }
        viewModel.updateStagePreference(at: indexPath.row, value: value)
    }
}
