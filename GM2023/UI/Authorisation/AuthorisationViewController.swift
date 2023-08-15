import Madog
import UIKit

class AuthorisationViewController: UIViewController {
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
        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.authoriseLocation()
    }
}

extension AuthorisationViewController: AuthorisationViewModelDelegate {
    func authorisationViewModel(
        _ authorisationViewModel: AuthorisationViewModel,
        didCompleteWithLocationAuthorisation: LocationAuthorisation,
        notificationAuthorisation: Bool
    ) {
        context?.change(to: .tabBarNavigation(), tokenData: .multi([.lineup, .stages, .histories, .settings]))
    }
}
