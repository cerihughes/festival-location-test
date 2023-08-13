import Madog
import UIKit

class AreasMapViewController: TypedViewController<AreasMapView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AreasMapViewModel

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: AreasMapViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Monitored Regions"

        let addRegion = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addRegion

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.backgroundColor = .white

        viewModel.delegate = self
        updateMap()
    }

    private func updateMap() {
        typedView.removeAllAndRender(areas: viewModel.areas)
    }

    @objc private func addTapped(_ item: UIBarButtonItem) {
        context?.navigateForward(token: .addArea, animated: true)
    }
}

extension AreasMapViewController: AreasMapViewModelDelegate {
    func areasMapViewModelDidUpdate(_ areasMapViewModel: AreasMapViewModel) {
        updateMap()
    }
}
