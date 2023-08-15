import Madog
import UIKit

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

        typedView.reloadStagesButton.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
    }

    @objc private func reloadTapped(_ item: UIButton) {
        context?.navigateForward(token: .reloadData, animated: true)
    }
}
