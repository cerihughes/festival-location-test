import Madog
import UIKit

class AddStageViewController: TypedViewController<AddStageView> {
    private weak var context: AnyForwardBackNavigationContext<Navigation>?
    private let viewModel: AddStageViewModel

    private lazy var done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))

    init(context: AnyForwardBackNavigationContext<Navigation>, viewModel: AddStageViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = done
        updateDoneButton()

        updateRadius(typedView.radiusSliderView.radiusSlider.value)

        typedView.nameField.addTarget(self, action: #selector(areaNameChanged), for: .editingChanged)
        typedView.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        typedView.useGPSButton.addTarget(
            self,
            action: #selector(useGPSTapped),
            for: .touchUpInside
        )
        typedView.radiusSliderView.radiusSlider.addTarget(
            self,
            action: #selector(sliderChanged),
            for: .valueChanged
        )
        typedView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { @MainActor in
            guard let location = await viewModel.getCurrentLocation() else { return }
            typedView.mapView.setRegion(
                .init(center: location.asMapCoordinate(), latitudinalMeters: 400, longitudinalMeters: 400),
                animated: true
            )
        }
    }

    @objc private func areaNameChanged(_ textField: UITextField) {
        viewModel.stageName = textField.trimmedText
        updateDoneButton()
    }

    @objc private func segmentChanged(_ segmentedControl: UISegmentedControl) {
        viewModel.mode = typedView.mode
        typedView.overlay = viewModel.overlay
        typedView.annotations = viewModel.annotations
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
        switch typedView.mode {
        case .single:
            viewModel.useSingleLocation(location)
        case .multiple:
            viewModel.addLocation(location)
            updateRadiusSlider()
        }
        typedView.overlay = viewModel.overlay
        typedView.annotations = viewModel.annotations
        updateDoneButton()
    }

    private func updateRadiusSlider() {
        switch viewModel.mode {
        case .single:
            typedView.radiusSliderView.radiusSlider.isEnabled = true
            typedView.radiusSliderView.radiusSlider.value = viewModel.radius
        case .multiple:
            typedView.radiusSliderView.radiusSlider.isEnabled = false
        }
        typedView.radiusSliderView.radiusLabel.text = viewModel.radiusDisplayString
    }

    private func updateRadius(_ radius: Float) {
        viewModel.radius = radius
        updateRadiusSlider()
    }

    private func updateRadiusOverlay(_ radius: Float) {
        updateRadius(radius)
        typedView.overlay = viewModel.overlay
    }

    private func updateDoneButton() {
        done.isEnabled = viewModel.isValid
    }
}

extension AddStageViewController: AddStageViewDelegate {
    func addStageView(_ addStageView: AddStageView, didSelect location: Location) {
        useLocation(location)
    }
}

private extension UITextField {
    var trimmedText: String? {
        guard let trimmed = text?.trimmed else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
}
