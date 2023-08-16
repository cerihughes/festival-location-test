import XCTest

@testable import GM2023

final class AuthorisationViewModelTests: XCTestCase {
    private var locationManager: MockLocationManager!
    private var notificationsManager: MockNotificationsManager!
    private var viewModel: AuthorisationViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        locationManager = .init()
        notificationsManager = .init()

        viewModel = .init(locationManager: locationManager, notificationsManager: notificationsManager)
    }

    override func tearDownWithError() throws {
        locationManager = nil
        notificationsManager = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func testNeverAsked_allPermissionsGiven() async throws {
        // This will be fired on startup in the real world
        viewModel.locationManager(locationManager, didChangeAuthorisation: .initial)

        XCTAssertEqual(viewModel.instruction, .inst1)
        XCTAssertEqual(viewModel.visibleButton, .initial)
        XCTAssertFalse(viewModel.canContinue)

        locationManager.requestWhenInUseAuthorisationResult = true
        viewModel.authoriseInUse()

        XCTAssertEqual(viewModel.instruction, .inst2)
        XCTAssertEqual(viewModel.visibleButton, .always)
        XCTAssertFalse(viewModel.canContinue)

        notificationsManager.authoriseResult = true
        viewModel.authoriseAlways()

        XCTAssertEqual(viewModel.instruction, .inst3)
        XCTAssertEqual(viewModel.visibleButton, .notifications)
        XCTAssertFalse(viewModel.canContinue)

        locationManager.requestAlwaysAuthorisationResult = true
        await viewModel.authoriseNotifications()

        XCTAssertEqual(viewModel.instruction, .inst3)
        XCTAssertEqual(viewModel.visibleButton, .notifications)
        XCTAssertTrue(viewModel.canContinue)
    }

    func testPrevouslyGivenInUse() async throws {
        viewModel.locationManager(locationManager, didChangeAuthorisation: .whenInUse)
        XCTAssertTrue(viewModel.canContinue)
    }

    func testPrevouslyGivenAlways() async throws {
        viewModel.locationManager(locationManager, didChangeAuthorisation: .always)
        XCTAssertTrue(viewModel.canContinue)
    }

    func testPrevouslyDenied() async throws {
        viewModel.locationManager(locationManager, didChangeAuthorisation: .denied)
        XCTAssertTrue(viewModel.canContinue)
    }
}
