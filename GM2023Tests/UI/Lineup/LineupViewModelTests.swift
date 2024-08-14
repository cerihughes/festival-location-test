import RealmSwift
import XCTest

@testable import GM2023

final class LineupViewModelTests: XCTestCase {
    private var mockDateFactory: MockDateFactory!
    private var mockLocalStorage: MockLocalStorage!
    private var localDataSource: LocalDataSource!
    private var dataRepository: DataRepository!
    private var locationMonitor: MockLocationMonitor!
    private var lineupLoader: LineupLoader!
    private var viewModel: LineupViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDateFactory = MockDateFactory()
        dateFactory = mockDateFactory

        mockLocalStorage = .init()
        localDataSource = DefaultLocalDataSource(localStorage: mockLocalStorage)
        localDataSource.setDefaultValues()

        let config = Realm.Configuration(inMemoryIdentifier: "LineupViewModelTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)
        locationMonitor = MockLocationMonitor()
        lineupLoader = DefaultLineupLoader(dataRepository: dataRepository)
        XCTAssertTrue(lineupLoader.importLineup(loader: .fileName(.greenMan2024FestivalLineup)))
    }

    override func tearDownWithError() throws {
        mockDateFactory = nil
        mockLocalStorage = nil
        localDataSource = nil
        dataRepository = nil
        locationMonitor = nil
        lineupLoader = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInitialData_beforeFestival() throws {
        mockDateFactory.setCurrentDate("13.08.2013 12:00")

        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .thursday)
        XCTAssertEqual(viewModel.selectedStage, .farOut)
        XCTAssertEqual(viewModel.numberOfSlots, 5)
        try assertSlot(at: 0, hasName: "Plastic Mermaids", timeStatus: .future)
        try assertSlot(at: 1, hasName: "Alice Boman", timeStatus: .future)
    }

    func testInitialData_afterFestival() throws {
        mockDateFactory.setCurrentDate("13.08.2033 12:00")

        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .thursday)
        XCTAssertEqual(viewModel.selectedStage, .farOut)
        XCTAssertEqual(viewModel.numberOfSlots, 5)
        try assertSlot(at: 0, hasName: "Plastic Mermaids", timeStatus: .past)
        try assertSlot(at: 1, hasName: "Alice Boman", timeStatus: .past)
    }

    func testInitialData_thursday() throws {
        mockDateFactory.setCurrentDay(.thursday, time: "13:00")
        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .thursday)
        XCTAssertEqual(viewModel.numberOfSlots, 5)
        try assertSlot(at: 0, hasName: "Plastic Mermaids", timeStatus: .pending)
        try assertSlot(at: 1, hasName: "Alice Boman", timeStatus: .future)
    }

    func testInitialData_friday() throws {
        mockDateFactory.setCurrentDay(.friday, time: "13:00")
        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .friday)
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Eve Appleton Band", timeStatus: .past)
        try assertSlot(at: 1, hasName: "Melin Melyn", timeStatus: .pending)
    }

    func testInitialData_friday_seenOnThursday() throws {
        mockDateFactory.setCurrentDay(.thursday, time: "12:00")

        createViewModel()
        viewModel.selectedDay = .friday
        viewModel.selectedStage = .mountain
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Eve Appleton Band", timeStatus: .future)
        try assertSlot(at: 1, hasName: "Melin Melyn", timeStatus: .future)
    }

    func testInitialData_friday_seenOnFridayMorning() throws {
        mockDateFactory.setCurrentDay(.friday, time: "10:00")

        createViewModel()
        viewModel.selectedDay = .friday
        viewModel.selectedStage = .mountain
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Eve Appleton Band", timeStatus: .pending)
        try assertSlot(at: 1, hasName: "Melin Melyn", timeStatus: .future)
    }

    func testInitialData_saturday() throws {
        mockDateFactory.setCurrentDay(.saturday, time: "12:30")
        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .saturday)
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Yasmin Williams", timeStatus: .current)
        try assertSlot(at: 1, hasName: "Julie Byrne", timeStatus: .future)
    }

    func testInitialData_sunday() throws {
        mockDateFactory.setCurrentDay(.sunday, time: "13:30")
        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .sunday)
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Kanda Bongo Man", timeStatus: .past)
        try assertSlot(at: 1, hasName: "Jake Xerxes Fussell", timeStatus: .current)
    }

    func testSundayTwist_thursday() throws {
        mockDateFactory.setCurrentDay(.thursday, time: "13:00")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .roundTheTwist

        XCTAssertEqual(viewModel.numberOfSlots, 6)
        try assertSlot(at: 0, hasName: "Kuntessa", timeStatus: .future)
        try assertSlot(at: 1, hasName: "Ash Kenazi", timeStatus: .future)
    }

    func testIndexToScrollTo_pending() {
        mockDateFactory.setCurrentDay(.sunday, time: "19:55")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .chaiWallahs

        XCTAssertEqual(viewModel.indexToScrollTo, 6)
    }

    func testIndexToScrollTo_current() {
        mockDateFactory.setCurrentDay(.sunday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .chaiWallahs

        XCTAssertEqual(viewModel.indexToScrollTo, 6)
    }

    func testIndexToScrollTo_allFinished() {
        mockDateFactory.setCurrentDay(.sunday, time: "23:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .rising

        XCTAssertEqual(viewModel.indexToScrollTo, 7)
    }

    func testIndexToScrollTo_wrongDay() throws {
        mockDateFactory.setCurrentDay(.sunday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .saturday
        viewModel.selectedStage = .chaiWallahs

        XCTAssertNil(viewModel.indexToScrollTo)
    }

    func testUpdateForLocalStage_sameDaySameStage() {
        mockDateFactory.setCurrentDay(.sunday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .chaiWallahs
        locationMonitor.currentStage = .chaiWallahs

        viewModel.updateForLocalStage()
        XCTAssertEqual(viewModel.selectedStage, .chaiWallahs)
    }

    func testUpdateForLocalStage_sameDayDifferentStage() {
        mockDateFactory.setCurrentDay(.sunday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .mountain
        locationMonitor.currentStage = .chaiWallahs

        viewModel.updateForLocalStage()
        XCTAssertEqual(viewModel.selectedStage, .chaiWallahs)
    }

    func testUpdateForLocalStage_differentDaySameStage() {
        mockDateFactory.setCurrentDay(.saturday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .mountain
        locationMonitor.currentStage = .mountain

        viewModel.updateForLocalStage()
        XCTAssertEqual(viewModel.selectedStage, .mountain)
    }

    func testUpdateForLocalStage_differentDayDifferentStage() {
        mockDateFactory.setCurrentDay(.friday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .walledGarden
        locationMonitor.currentStage = .roundTheTwist

        viewModel.updateForLocalStage()
        XCTAssertEqual(viewModel.selectedStage, .walledGarden)
    }

    private func createViewModel() {
        viewModel = .init(
            localDataSource: localDataSource,
            dataRepository: dataRepository,
            locationMonitor: locationMonitor
        )
    }

    private func assertSlot(
        at index: Int,
        hasName name: String,
        timeStatus: LineupTableViewCell.TimeStatus,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let viewData = try XCTUnwrap(viewModel.viewData(at: index))
        XCTAssertEqual(name, viewData.name, file: file, line: line)
        XCTAssertEqual(timeStatus, viewData.timeStatus, file: file, line: line)
    }
}

private extension MockDateFactory {
    func setCurrentDay(_ day: GMDay, time: String) {
        setCurrentDate(day.dd_MM_yyyy_HH_mm(time: time))
    }
}

private extension MockLocationMonitor {
    var currentStage: GMStage? {
        get {
            currentLocation.flatMap(GMStage.create)
        }
        set {
            currentLocation = newValue?.identifier
        }
    }
}
