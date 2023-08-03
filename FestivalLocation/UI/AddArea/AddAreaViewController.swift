import Madog
import UIKit

class AddAreaViewController: UIViewController {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AddAreaViewModel
    private let addAreaView = AddAreaView()

    private lazy var done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: AddAreaViewModel) {
        self.context = context
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

        navigationItem.rightBarButtonItem = done
        updateDoneButton()

        addAreaView.nameField.addTarget(self, action: #selector(areaNameChanged), for: .editingChanged)
        addAreaView.useCurrentButton.addTarget(self, action: #selector(useCurrentTapped), for: .touchUpInside)
        addAreaView.delegate = self
    }

    @objc private func areaNameChanged(_ textField: UITextField) {
        viewModel.areaName = textField.trimmedText
        updateDoneButton()
    }

    @objc private func useCurrentTapped(_ button: UIButton) {
        Task { @MainActor in
            guard let location = await viewModel.useCurrentLocation() else { return }
            updateLocation(location: location)
        }
    }

    @objc private func doneTapped(_ item: UIBarButtonItem) {
        guard viewModel.create() else { return }
        context?.navigateBack(animated: true)
    }

    private func updateLocation(location: Location) {
        viewModel.location = location
        addAreaView.render(location: location)
        updateDoneButton()
    }

    private func updateDoneButton() {
        done.isEnabled = viewModel.isValid
    }
}

extension AddAreaViewController: AddAreaViewDelegate {
    func areasMapView(_ areasMapView: AddAreaView, didSelect location: Location) {
        updateLocation(location: location)
    }
}

private extension UITextField {
    var trimmedText: String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespaces) else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
}
