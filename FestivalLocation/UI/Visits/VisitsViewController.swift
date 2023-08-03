import UIKit

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

        viewModel.delegate = self
    }
}

extension VisitsViewController: VisitsViewModelDelegate {
    func visitsViewModelDidUpdate(_ visitsViewModel: VisitsViewModel) {
    }
}
