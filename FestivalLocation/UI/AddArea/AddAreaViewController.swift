import UIKit

class AddAreaViewController: UIViewController {
    private let viewModel: AddAreaViewModel
    private let addAreaView = AddAreaView()

    init(viewModel: AddAreaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = addAreaView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Monitored Regions"

        let addRegion = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addRegion

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.backgroundColor = .white

        addAreaView.isMapTappable = false
        addAreaView.delegate = self

        viewModel.delegate = self

        addAreaView.removeAllAndRender(areas: viewModel.areas)
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
        alertController.popoverPresentationController?.sourceView = addAreaView

        present(alertController, animated: true, completion: nil)
    }

    private func createAreaAtCurrentLocation() {
        Task {
            await viewModel.createAreaAtCurrentLocation()
        }
    }

    private func selectLocation() {
        addAreaView.isMapTappable = true
    }
}

extension AddAreaViewController: AddAreaViewModelDelegate {
    func addAreaViewModel(_ addAreaViewModel: AddAreaViewModel, didAddArea area: Area) {
        addAreaView.render(areas: [area])
    }

    func addAreaViewModel(_ addAreaViewModel: AddAreaViewModel, didRemoveArea area: Area) {

    }
}

extension AddAreaViewController: AddAreaViewDelegate {
    func addAreaView(_ addAreaView: AddAreaView, didSelect location: Location) {
        addAreaView.isMapTappable = false
        viewModel.createArea(at: location)
    }
}
