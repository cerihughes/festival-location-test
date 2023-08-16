import SnapKit
import UIKit

class AuthorisationView: UIView {
    enum VisibleButton {
        case initial, always, notifications
    }
    let backgroundImageView = UIImageView()
    let textContainer = UIView.createContainer()
    let titleLabel = UILabel.createLabel(textStyle: .title1)
    let descriptionLabel = UILabel.createLabel(textStyle: .title3)
    let instructionLabel = UILabel.createLabel(textStyle: .body)

    let buttonsContainer = UIView.createContainer()
    let skipButtonContainer = UIView.createContainer()
    let initialButton = UIButton.createButton(text: "Give Location Access")
    let alwaysButton = UIButton.createButton(text: "Give \"Always\" Location Access")
    let notificationsButton = UIButton.createButton(text: "Give Notifications Access")
    let skipButton = UIButton.createButton(text: "Skip Notification")

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        backgroundImageView.alpha = 0.2
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = .init(named: "background")

        titleLabel.text = "Green Man 2023"
        descriptionLabel.text = .descriptionText
        instructionLabel.textColor = .darkGray

        addSubviews(backgroundImageView, textContainer, buttonsContainer, skipButtonContainer)
        textContainer.addSubviews(titleLabel, descriptionLabel, instructionLabel)
        buttonsContainer.addSubviews(initialButton, alwaysButton, notificationsButton, skipButton)
        skipButtonContainer.addSubview(skipButton)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }

        buttonsContainer.snp.makeConstraints { make in
            make.top.equalTo(textContainer.snp.bottom).offset(48)
            make.centerX.equalTo(safeAreaLayoutGuide).inset(16)
        }

        skipButtonContainer.snp.makeConstraints { make in
            make.bottom.centerX.equalTo(safeAreaLayoutGuide).inset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleLabel)
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(16)
        }

        initialButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.width.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }

        alwaysButton.snp.makeConstraints { make in
            make.edges.equalTo(initialButton)
        }

        notificationsButton.snp.makeConstraints { make in
            make.edges.equalTo(initialButton)
        }

        skipButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }

    var visibleButton: VisibleButton? {
        didSet {
            initialButton.isHidden = visibleButton != .initial
            alwaysButton.isHidden = visibleButton != .always
            notificationsButton.isHidden = visibleButton != .notifications
        }
    }
}

private extension UIView {
    static func createContainer() -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.darkGray.cgColor
        container.backgroundColor = .cellBackground1.withAlphaComponent(0.9)
        return container
    }
}

private extension UIButton {
    static func createButton(text: String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.setTitle(text, for: .normal)
        return button
    }
}

private extension UILabel {
    static func createLabel(textStyle: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: textStyle)
        return label
    }
}

private extension String {
    static let descriptionText = """
This app needs "Location" and "Notification" permissions.
"""
}
