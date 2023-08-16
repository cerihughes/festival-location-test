import Foundation

protocol AuthorisationViewModelDelegate: AnyObject {
    func authorisationViewModel(
        _ authorisationViewModel: AuthorisationViewModel,
        didCompleteWithLocationAuthorisation: LocationAuthorisation,
        notificationAuthorisation: Bool
    )
}

class AuthorisationViewModel {
    private let locationManager: LocationManager
    private let notificationsManager: NotificationsManager

    private var firstPermissionReceived = false

    weak var delegate: AuthorisationViewModelDelegate?

    var instruction: String?
    var visibleButton: AuthorisationView.VisibleButton?
    var canContinue = false

    init(locationManager: LocationManager, notificationsManager: NotificationsManager) {
        self.locationManager = locationManager
        self.notificationsManager = notificationsManager

        locationManager.authorisationDelegate = self
    }

    func authoriseInUse() {
        locationManager.requestWhenInUseAuthorisation()
    }

    func authoriseAlways() {
        locationManager.requestAlwaysAuthorisation()
    }

    @MainActor
    func authoriseNotifications() async {
        guard let locationAuthorisation = locationManager.lastAuthorisationStatus else { return }
        let result = await notificationsManager.authorise()
        canContinue = true
        delegate?.authorisationViewModel(
            self,
            didCompleteWithLocationAuthorisation: locationAuthorisation,
            notificationAuthorisation: result
        )
    }
}

extension AuthorisationViewModel: LocationManagerAuthorisationDelegate {
    func locationManager(
        _ locationManager: LocationManager,
        didChangeAuthorisation authorisation: LocationAuthorisation
    ) {
        if authorisation != .initial && firstPermissionReceived == false {
            canContinue = true
        } else {
            firstPermissionReceived = true
            instruction = authorisation.nextInstruction
            visibleButton = authorisation.visibleButton
            canContinue = authorisation == .denied
        }

        delegate?.authorisationViewModel(
            self,
            didCompleteWithLocationAuthorisation: authorisation,
            notificationAuthorisation: false
        )
    }
}

private extension LocationAuthorisation {
    var nextInstruction: String {
        switch self {
        case .initial:
            return .inst1
        case .whenInUse:
            return .inst2
        case .always:
            return .inst3
        case .denied:
            return .inst4
        }
    }

    var visibleButton: AuthorisationView.VisibleButton? {
        switch self {
        case .initial:
            return .initial
        case .whenInUse:
            return .always
        case .always:
            return .notifications
        case .denied:
            return nil
        }
    }
}

extension String {
    static let inst1 = """
The app needs "General" location permissions to get your location when you're using the app.

Press the button below and choose "Allow While Using App"
"""

    static let inst2 = """
The app needs "Always" locations permissions to periodically get your permission when you're not using the app.

Press the button below and choose "Change to Always Allow"
"""

    static let inst3 = """
Finally, the app needs "Notifications" permissions to send you now/next stage times when you get to a stage.

Press the button below and choose "Allow"
"""

    static let inst4 = """
Some permissions have been denied.
"""
}
