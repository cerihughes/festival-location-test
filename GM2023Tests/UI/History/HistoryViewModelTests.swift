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
        XCTAssertTrue(lineupLoader.importLineup(loader: .fileName(.greenMan2024FestivalLineup)))
        XCTAssertTrue(areasLoader.importAreas(loader: .fileName(.greenMan2024FestivalAreas)))
    }

    override func tearDownWithError() throws {
        dateFormatter = nil
        dataRepository = nil
        locationManager = nil
        viewModel = nil
        delegate = nil
        try super.tearDownWithError()
    }

    func testArriveAndLeaveDuringSlot() {
        createEvent(at: .mountain, day: .friday, startTimeString: "13:20", endTimeString: "13:55")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .mountain, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 1)
        XCTAssertEqual(viewModel.viewData(at: 0)?.title, "Melin Melyn for 35 minutes")
    }

    func testSameStage_allDay() {
        createEvent(at: .mountain, day: .friday, startTimeString: "10:00", endTimeString: "23:59")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .mountain, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

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

    func testSameStage_allThursday() {
        createEvent(at: .roundTheTwist, startDateString: "17.08.2023 12:00", endDateString: "18.08.2023 05:00")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .roundTheTwist, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 7)
        let expected = (0...7).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "Stone Club DJs for 90 minutes",
            "Moof Magazine for 90 minutes",
            "Pet Deaths Disco for 90 minutes",
            "James Endeacott for 90 minutes",
            "The Social Soundsystem for 90 minutes",
            "Lice b2b PVA for 90 minutes",
            "Flying Mojito Bros for 120 minutes"
        ])
    }

    func testSameStage_shortVisits() {
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "15:45", endTimeString: "16.10")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "18:50", endTimeString: "19.10")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "22:00", endTimeString: "22.14")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "23:15", endTimeString: "23:50")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .roundTheTwist, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 2)
        let expected = (0...2).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "The Social Soundsystem for 29 minutes",
            "Lice b2b PVA for 20 minutes"
        ])
    }

    func testSameStage_microVisits() {
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "20:45", endTimeString: "20.46")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "20:47", endTimeString: "20.48")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "20:49", endTimeString: "20.51")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "20:55", endTimeString: "20.59")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "21:00", endTimeString: "21.03")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "21:05", endTimeString: "21.09")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "21:25", endTimeString: "21.29")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "21:30", endTimeString: "21.37")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .roundTheTwist, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 1)
        let expected = (0...1).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "James Endeacott for 26 minutes"
        ])
    }

    func testSameStage_multipleVisits() {
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "14:00", endTimeString: "14:20")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "14:50", endTimeString: "15.20")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "15:45", endTimeString: "16.45")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "17:45", endTimeString: "19.45")
        createEvent(at: .roundTheTwist, day: .thursday, startTimeString: "21:00", endTimeString: "23.55")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .roundTheTwist, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 6)
        let expected = (0...6).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "Stone Club DJs for 45 minutes",
            "Moof Magazine for 75 minutes",
            "Pet Deaths Disco for 45 minutes",
            "James Endeacott for 60 minutes",
            "The Social Soundsystem for 90 minutes",
            "Lice b2b PVA for 25 minutes"
        ])
    }

    func testMultipleStages_multipleDays() {
        createEvent(at: .mountain, day: .thursday, startTimeString: "14:00", endTimeString: "18:00")
        createEvent(at: .farOut, day: .thursday, startTimeString: "18:30", endTimeString: "20:00")
        createEvent(at: .cinedrome, day: .thursday, startTimeString: "21:00", endTimeString: "22:00")
        createEvent(at: .chaiWallahs, day: .thursday, startTimeString: "22:30", endTimeString: "23:55")
        createEvent(at: .chaiWallahs, day: .friday, startTimeString: "00:00", endTimeString: "02:00")

        createEvent(at: .mountain, day: .friday, startTimeString: "14:00", endTimeString: "18:00")
        createEvent(at: .farOut, day: .friday, startTimeString: "18:30", endTimeString: "20:00")
        createEvent(at: .cinedrome, day: .friday, startTimeString: "21:00", endTimeString: "22:00")
        createEvent(at: .chaiWallahs, day: .friday, startTimeString: "22:30", endTimeString: "23:55")
        createEvent(at: .chaiWallahs, day: .saturday, startTimeString: "00:00", endTimeString: "02:00")

        let dataLoaded = expectation(description: "Data Loaded")
        createViewModel(stage: .chaiWallahs, delegate: .init(testExpectation: dataLoaded))

        waitForExpectations(timeout: 1)

        XCTAssertEqual(viewModel.numberOfItems, 5)
        let expected = (0...5).compactMap { viewModel.viewData(at: $0) }
            .map { $0.title }

        XCTAssertEqual(expected, [
            "TC & the Groove Family for 70 minutes",
            "Diplomats Of Sound DJs for 120 minutes",
            "The Allergies for 60 minutes",
            "Hannabiell & the Midnight Blue Collective for 60 minutes",
            "Diplomats Of Sound DJs for 60 minutes"
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
