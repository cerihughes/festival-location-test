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

        updateRadius(addAreaView.radiusSliderView.radiusSlider.value)

        addAreaView.nameField.addTarget(self, action: #selector(areaNameChanged), for: .editingChanged)
        addAreaView.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        addAreaView.useGPSButton.addTarget(
            self,
            action: #selector(useGPSTapped),
            for: .touchUpInside
        )
        addAreaView.radiusSliderView.radiusSlider.addTarget(
            self,
            action: #selector(sliderChanged),
            for: .valueChanged
        )
        addAreaView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { @MainActor in
            guard let location = await viewModel.getCurrentLocation() else { return }
            addAreaView.mapView.setRegion(
                .init(center: location.asMapCoordinate(), latitudinalMeters: 400, longitudinalMeters: 400),
                animated: true
            )
        }
    }

    @objc private func areaNameChanged(_ textField: UITextField) {
        viewModel.areaName = textField.trimmedText
        updateDoneButton()
    }

    @objc private func segmentChanged(_ segmentedControl: UISegmentedControl) {
        viewModel.mode = addAreaView.mode
        addAreaView.overlay = viewModel.overlay
        addAreaView.annotations = viewModel.annotations
        updateRadiusSlider()
        updateDoneButton()
    }

    @objc private func useGPSTapped(_ button: UIButton) {
        Task { @MainActor in
            guard let location = await viewModel.getCurrentLocation() else { return }
            useLocation(location)
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

    @objc private func doneTapped(_ item: UIBarButtonItem) {
        guard viewModel.create() else { return }
        context?.navigateBack(animated: true)
    }

    private func useLocation(_ location: Location) {
        switch addAreaView.mode {
        case .single:
            viewModel.useSingleLocation(location)
        case .multiple:
            viewModel.addLocation(location)
            updateRadiusSlider()
        }
        addAreaView.overlay = viewModel.overlay
        addAreaView.annotations = viewModel.annotations
        updateDoneButton()
    }

    private func updateRadiusSlider() {
        switch viewModel.mode {
        case .single:
            addAreaView.radiusSliderView.radiusSlider.isEnabled = true
            addAreaView.radiusSliderView.radiusSlider.value = viewModel.radius
        case .multiple:
            addAreaView.radiusSliderView.radiusSlider.isEnabled = false
        }
        addAreaView.radiusSliderView.radiusLabel.text = viewModel.radiusDisplayString
    }

    private func updateRadius(_ radius: Float) {
        viewModel.radius = radius
        updateRadiusSlider()
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
        useLocation(location)
    }
}

private extension UITextField {
    var trimmedText: String? {
        guard let trimmed = text?.trimmed else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
}
