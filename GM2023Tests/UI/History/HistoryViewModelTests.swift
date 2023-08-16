import RealmSwift
import XCTest

@testable import GM2023

final class HistoryViewModelTests: XCTestCase {
    private var dateFormatter: DateFormatter!
    private var dataRepository: DataRepository!
    private var locationManager: MockLocationManager!
    private var viewModel: HistoryViewModel!
    private var delegate: HistoryViewModelDelegate!

    override func setUpWithError() throws {
        try super.setUpWithError()

        dateFormatter = .dd_MM_yyyy_HH_mm()

        let config = Realm.Configuration(inMemoryIdentifier: "HistoryViewModelTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)
        locationManager = .init()

        let lineupLoader = DefaultLineupLoader(dataRepository: dataRepository)
        let areasLoader = DefaultAreasLoader(dataRepository: dataRepository)
        XCTAssertTrue(lineupLoader.importLineup(loader: .fileName(.greenMan2023FestivalLineup)))
        XCTAssertTrue(areasLoader.importAreas(loader: .fileName(.greenMan2023FestivalAreas)))
    }

    override func tearDownWithError() throws {
        dateFormatter = nil
        dataRepository = nil
        locationManager = nil
        viewModel = nil
        delegate = nil
        try super.tearDownWithError()
    }

    func testSameStageAllDay() throws {
        createEvent(at: .mountain, day: .friday, startTimeString: "10:00", endTimeString: "23:59")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .mountain, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 100)

        XCTAssertEqual(viewModel.numberOfItems, 8)
        let expected = (0...7).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "Eve Appleton Band for 30 minutes",
            "Melin Melyn for 45 minutes",
            "James Ellis Ford for 60 minutes",
            "Dur-Dur Band Int. for 60 minutes",
            "Beth Orton for 60 minutes",
            "The Delgados for 60 minutes",
            "The Comet Is Coming for 75 minutes",
            "Devo for 59 minutes"
        ])
    }

    private func createEvent(at stage: GMStage, day: GMDay, startTimeString: String, endTimeString: String) {
        createEvent(
            at: stage,
            startDateString: day.dd_MM_yyyy_HH_mm(time: startTimeString),
            endDateString: day.dd_MM_yyyy_HH_mm(time: endTimeString)
        )
    }

    private func createEvent(at stage: GMStage, startDateString: String, endDateString: String) {
        guard
            let start = dateFormatter.date(from: startDateString),
            let end = dateFormatter.date(from: endDateString)
        else { return }

        let areaName = stage.identifier
        let entry = Event.create(areaName: areaName, timestamp: start, kind: .entry)
        let exit = Event.create(areaName: areaName, timestamp: end, kind: .exit)
        dataRepository.add(entry)
        dataRepository.add(exit)
    }

    private func createViewModel(stage: GMStage, delegate: DelegateWaiter? = nil) {
        viewModel = .init(areaName: stage.identifier, dataRepository: dataRepository, locationManager: locationManager)
        self.delegate = delegate
        viewModel.delegate = delegate
    }
}

private class DelegateWaiter: HistoryViewModelDelegate {
    private let testExpectation: XCTestExpectation

    init(testExpectation: XCTestExpectation) {
        self.testExpectation = testExpectation
    }

    func historyViewModelDidUpdate(_ historyViewModel: HistoryViewModel) {
        testExpectation.fulfill()
    }
}
