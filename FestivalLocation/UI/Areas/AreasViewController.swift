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
        viewModel.authoriseIfNeeded()
    }

    @objc private func addTapped(_ item: UIBarButtonItem) {
        presentModal()
    }

    private func presentModal() {
        let alert = UIAlertController(title: "Add Region", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Use Current Location", style: .default) { [weak self] _ in
            self?.createRegionAtCurrentLocation()
        })
        alert.addAction(.init(title: "Select Location", style: .default) { [weak self] _ in
            self?.selectLocation()
        })
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    private func createRegionAtCurrentLocation() {
        Task {
            await viewModel.createRegionAtCurrentLocation()
        }
    }

    private func selectLocation() {
        areasView.isMapTappable = true
    }
}

extension AreasViewController: AreasViewDelegate {
    func areasView(_ areasView: AreasView, didSelect location: Location) {
        areasView.isMapTappable = false
        viewModel.createRegion(at: location)
    }
}
