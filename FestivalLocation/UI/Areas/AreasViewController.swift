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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Monitored Regions"

        let addRegion = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addRegion

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.backgroundColor = .white

        areasView.isMapTappable = false
        areasView.delegate = self

        viewModel.delegate = self
        viewModel.authoriseIfNeeded()

        areasView.removeAllAndRender(areas: viewModel.areas)
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
        alertController.popoverPresentationController?.sourceView = areasView

        present(alertController, animated: true, completion: nil)
    }

    private func createAreaAtCurrentLocation() {
        Task {
            await viewModel.createAreaAtCurrentLocation()
        }
    }

    private func selectLocation() {
        areasView.isMapTappable = true
    }
}

extension AreasViewController: AreasViewModelDelegate {
    func areasViewModel(_ areasViewModel: AreasViewModel, didAddArea area: Area) {
        areasView.render(areas: [area])
    }

    func areasViewModel(_ areasViewModel: AreasViewModel, didRemoveArea area: Area) {

    }
}

extension AreasViewController: AreasViewDelegate {
    func areasView(_ areasView: AreasView, didSelect location: Location) {
        areasView.isMapTappable = false
        viewModel.createArea(at: location)
    }
}
