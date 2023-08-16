import Madog
import UIKit

class AuthorisationViewController: TypedViewController<AuthorisationView> {
    private weak var context: AnyContext<Navigation>?
    private let viewModel: AuthorisationViewModel

    init(context: AnyContext<Navigation>, viewModel: AuthorisationViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typedView.initialButton.addTarget(self, action: #selector(authoriseInitial), for: .touchUpInside)
        typedView.alwaysButton.addTarget(self, action: #selector(authoriseAlways), for: .touchUpInside)
        typedView.notificationsButton.addTarget(self, action: #selector(authoriseNotifications), for: .touchUpInside)
        typedView.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)

        viewModel.delegate = self
    }

    @objc private func authoriseInitial(_ button: UIButton) {
        viewModel.authoriseInUse()
    }

    @objc private func authoriseAlways(_ button: UIButton) {
        viewModel.authoriseAlways()
    }

    @objc private func authoriseNotifications(_ button: UIButton) {
        Task {
            await viewModel.authoriseNotifications()
        }
    }

    @objc private func skip(_ button: UIButton) {
        context?.showMainUI()
    }
}

extension AuthorisationViewController: AuthorisationViewModelDelegate {
    func authorisationViewModel(
        _ authorisationViewModel: AuthorisationViewModel,
        didCompleteWithLocationAuthorisation: LocationAuthorisation,
        notificationAuthorisation: Bool
    ) {
        if viewModel.canContinue {
            context?.showMainUI()
        } else {
            typedView.instructionLabel.text = viewModel.instruction
            typedView.visibleButton = viewModel.visibleButton
        }
    }
}

private extension Context where T == Navigation {
    func showMainUI() {
        change(to: .tabBarNavigation(), tokenData: .multi([.lineup, .stages, .histories, .settings]))
    }
}
