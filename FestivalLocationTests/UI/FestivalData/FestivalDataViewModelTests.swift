import RealmSwift
import XCTest

@testable import FestivalLocation

final class FestivalDataViewModelTests: XCTestCase {
    private var mockDateFactory: MockDateFactory!
    private var dataRepository: DataRepository!
    private var lineupLoader: FileLineupLoader!
    private var viewModel: FestivalDataViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDateFactory = MockDateFactory()
        mockDateFactory.setCurrentDate("13.08.2023 12:00")
        dateFactory = mockDateFactory

        let config = Realm.Configuration(inMemoryIdentifier: "FestivalDataViewModelTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)
        lineupLoader = FileLineupLoader(fileName: .greenMan2023FestivalLineup, dataRepository: dataRepository)
    }

    override func tearDownWithError() throws {
        dataRepository = nil
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
        try assertSlot(at: 0, hasName: "Plastic Mermaids", timeStatus: .pending)
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

    func testInitialData_saturday() throws {
        mockDateFactory.setCurrentDay(.saturday, time: "13:00")
        createViewModel()
        XCTAssertEqual(viewModel.selectedDay, .saturday)
        XCTAssertEqual(viewModel.numberOfSlots, 8)
        try assertSlot(at: 0, hasName: "Yasmin Williams", timeStatus: .current)
        try assertSlot(at: 1, hasName: "Julie Byrne", timeStatus: .future)
    }

    func testInitialData_sunday() throws {
        mockDateFactory.setCurrentDay(.sunday, time: "13:00")
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
        try assertSlot(at: 0, hasName: "Kuntessa", timeStatus: .pending)
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

        XCTAssertEqual(viewModel.indexToScrollTo, 6)
    }

    func testIndexToScrollTo_wrongDay() throws {
        mockDateFactory.setCurrentDay(.sunday, time: "20:05")
        createViewModel()
        viewModel.selectedDay = .saturday
        viewModel.selectedStage = .chaiWallahs

        XCTAssertNil(viewModel.indexToScrollTo)
    }

    private func createViewModel() {
        viewModel = .init(dataRepository: dataRepository, lineupLoader: lineupLoader)
    }

    private func assertSlot(
        at index: Int,
        hasName name: String,
        timeStatus: FestivalSlotTableViewCell.TimeStatus,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let viewData = try XCTUnwrap(viewModel.viewData(at: index))
        XCTAssertEqual(name, viewData.name, file: file, line: line)
        XCTAssertEqual(timeStatus, viewData.timeStatus, file: file, line: line)
    }
}

private extension MockDateFactory {
    func setCurrentDay(_ day: FestivalDataView.Day, time: String) {
        let currentDate = "\(day.dateString) \(time)"
        setCurrentDate(currentDate)
    }
}

private extension FestivalDataView.Day {
    var dateString: String {
        switch self {
        case .thursday:
            return "17.08.2023"
        case .friday:
            return "18.08.2023"
        case .saturday:
            return "19.08.2023"
        case .sunday:
            return "20.08.2023"
        }
    }
}
