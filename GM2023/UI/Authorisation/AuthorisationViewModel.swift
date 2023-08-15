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

    weak var delegate: AuthorisationViewModelDelegate?

    init(locationManager: LocationManager, notificationsManager: NotificationsManager) {
        self.locationManager = locationManager
        self.notificationsManager = notificationsManager

        locationManager.authenticationDelegate = self
    }

    func authoriseLocation() {
        locationManager.requestWhenInUseAuthorisation()
    }

    private func authoriseNotifications(locationAuthorisation: LocationAuthorisation) {
        Task { @MainActor in
            let result = await notificationsManager.authorise()
            delegate?.authorisationViewModel(
                self,
                didCompleteWithLocationAuthorisation: locationAuthorisation,
                notificationAuthorisation: result
            )
        }
    }
}

extension AuthorisationViewModel: LocationManagerAuthenticationDelegate {
    func locationManager(
        _ locationManager: LocationManager,
        didChangeAuthorisation authorisation: LocationAuthorisation
    ) {
        switch authorisation {
        case .initial:
            locationManager.requestWhenInUseAuthorisation()
        case .whenInUse:
            locationManager.requestAlwaysAuthorisation()
        case .always, .denied:
            authoriseNotifications(locationAuthorisation: authorisation)
        }
    }
}
