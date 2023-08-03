import Madog
import UIKit

class AreasMapViewController: UIViewController {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AreasMapViewModel
    private let areasMapView = AreasMapView()

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: AreasMapViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = areasMapView
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
        areasMapView.removeAllAndRender(areas: viewModel.areas)
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
