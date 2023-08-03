import UIKit

class AreasMapViewController: UIViewController {
    private let viewModel: AreasMapViewModel
    private let areasMapView = AreasMapView()

    init(viewModel: AreasMapViewModel) {
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

        areasMapView.isMapTappable = false
        areasMapView.delegate = self

        viewModel.delegate = self

        areasMapView.removeAllAndRender(areas: viewModel.areas)
    }

    @objc private func addTapped(_ item: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Region", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Use Current Location", style: .default) { [weak self] _ in
            self?.createAreaAtCurrentLocation()
        })
        alertController.addAction(.init(title: "Select Location", style: .default) { [weak self] _ in
            self?.selectLocation()
        })
        alertController.addAction(.init(title: "Cancel", style: .cancel))

        alertController.popoverPresentationController?.barButtonItem = item
        alertController.popoverPresentationController?.sourceView = areasMapView

        present(alertController, animated: true, completion: nil)
    }

    private func createAreaAtCurrentLocation() {
        Task {
            await viewModel.createAreaAtCurrentLocation()
        }
    }

    private func selectLocation() {
        areasMapView.isMapTappable = true
    }
}

extension AreasMapViewController: AreasMapViewModelDelegate {
    func areasMapViewModel(_ areasMapViewModel: AreasMapViewModel, didAddArea area: Area) {
        areasMapView.render(areas: [area])
    }

    func areasMapViewModel(_ areasMapViewModel: AreasMapViewModel, didRemoveArea area: Area) {

    }
}

extension AreasMapViewController: AreasMapViewDelegate {
    func areasMapView(_ areasMapView: AreasMapView, didSelect location: Location) {
        areasMapView.isMapTappable = false
        viewModel.createArea(at: location)
    }
}
