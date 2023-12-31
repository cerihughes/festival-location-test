import Madog
import UIKit

class StagesViewController: TypedViewController<StagesView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: StagesViewModel

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: StagesViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addArea = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addArea

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.backgroundColor = .white

        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMap()
    }

    private func updateMap() {
        typedView.removeAllAndRender(mapCircles: viewModel.mapCircles)
    }

    @objc private func addTapped(_ item: UIBarButtonItem) {
        context?.navigateForward(token: .addStage, animated: true)
    }
}

extension StagesViewController: StagesViewModelDelegate {
    func stagesViewModelDidUpdate(_ stagesViewModel: StagesViewModel) {
        updateMap()
    }
}
