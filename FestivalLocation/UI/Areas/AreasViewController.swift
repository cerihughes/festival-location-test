import UIKit

class AreasViewController: UIViewController {
    private let viewModel: AreasViewModel
    private let areasView = AreasView()

    init(viewModel: AreasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = areasView
    }
}
