import Madog
import UIKit

class AddAreaViewController: UIViewController {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AddAreaViewModel
    private let addAreaView = AddAreaView()

    private lazy var done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

    private var radius: Double {
        Double(addAreaView.locationAndRadiusView.radiusSlider.value)
    }

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

        updateRadius(addAreaView.locationAndRadiusView.radiusSlider.value)

        addAreaView.nameField.addTarget(self, action: #selector(areaNameChanged), for: .editingChanged)
        addAreaView.currentLocationView.useCurrentButton.addTarget(
            self,
            action: #selector(useCurrentTapped),
            for: .touchUpInside
        )
        addAreaView.locationAndRadiusView.radiusSlider.addTarget(
            self,
            action: #selector(sliderChanged),
            for: .valueChanged
        )
        addAreaView.multipleLocationsView.addCurrentPosition.addTarget(
            self,
            action: #selector(addCurrentTapped),
            for: .touchUpInside
        )
        addAreaView.delegate = self
    }

    @objc private func areaNameChanged(_ textField: UITextField) {
        viewModel.areaName = textField.trimmedText
        updateDoneButton()
    }

    @objc private func useCurrentTapped(_ button: UIButton) {
        Task { @MainActor in
            guard let location = await viewModel.getCurrentLocation() else { return }
            updateLocation(location)
        }
    }

    @objc private func sliderChanged(_ slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                updateRadiusOverlay(slider.value)
            default:
                updateRadius(slider.value)
            }
        }
    }

    @objc private func addCurrentTapped(_ button: UIButton) {
        Task { @MainActor in
            guard let location = await viewModel.getCurrentLocation() else { return }
            addLocation(location)
        }
    }

    @objc private func doneTapped(_ item: UIBarButtonItem) {
        guard viewModel.create() else { return }
        context?.navigateBack(animated: true)
    }

    private func updateLocation(_ location: Location) {
        viewModel.location = location
        addAreaView.overlay = viewModel.overlay
        updateDoneButton()
    }

    private func addLocation(_ location: Location) {
        viewModel.addLocation(location)
        addAreaView.overlay = viewModel.overlay
        updateDoneButton()
    }

    private func updateRadius(_ radius: Float) {
        viewModel.radius = radius
        addAreaView.locationAndRadiusView.radiusLabel.text = viewModel.radiusDisplayString
    }

    private func updateRadiusOverlay(_ radius: Float) {
        updateRadius(radius)
        addAreaView.overlay = viewModel.overlay
    }

    private func updateDoneButton() {
        done.isEnabled = viewModel.isValid
    }
}

extension AddAreaViewController: AddAreaViewDelegate {
    func areasMapView(_ areasMapView: AddAreaView, didSelect location: Location) {
        updateLocation(location)
    }
}

private extension UITextField {
    var trimmedText: String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespaces) else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
}
