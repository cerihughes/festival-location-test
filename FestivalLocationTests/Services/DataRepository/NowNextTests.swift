import RealmSwift
import XCTest

@testable import FestivalLocation

class NowNextTests: XCTestCase {
    private var mockDateFactory: MockDateFactory!
    private var dataRepository: DataRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDateFactory = MockDateFactory()
        dateFactory = mockDateFactory

        let config = Realm.Configuration(inMemoryIdentifier: "LineupLoaderTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)

        let lineupLoader = DefaultLineupLoader(
            source: .local(.greenMan2023FestivalLineup),
            dataRepository: dataRepository
        )
        XCTAssertTrue(lineupLoader.importLineup())
    }

    override func tearDownWithError() throws {
        dataRepository = nil
        try super.tearDownWithError()
    }

    func testBeforeFestival() {
        mockDateFactory.setCurrentDate("13.08.2013 12:00")

        let nowNext = dataRepository.nowNext(for: .mountain)
        XCTAssertNil(nowNext)
    }

    func testAfterFestival() {
        mockDateFactory.setCurrentDate("13.08.2033 12:00")

        let nowNext = dataRepository.nowNext(for: .mountain)
        XCTAssertNil(nowNext)
    }

    func testThursday_mountain() {
        mockDateFactory.setCurrentDate("17.08.2023 12:00")

        let nowNext = dataRepository.nowNext(for: .mountain)
        XCTAssertNil(nowNext)
    }

    func testThursday_farOut() throws {
        mockDateFactory.setCurrentDate("17.08.2023 12:00")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .farOut))
        let next = try XCTUnwrap(nowNext.next)
        XCTAssertFalse(nowNext.isNowStarted)
        XCTAssertEqual(nowNext.now.name, "Plastic Mermaids")
        XCTAssertEqual(next.name, "Alice Boman")
    }

    func testThursday_farOut_last() throws {
        mockDateFactory.setCurrentDate("17.08.2023 22:45")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .farOut))
        XCTAssertTrue(nowNext.isNowStarted)
        XCTAssertEqual(nowNext.now.name, "Spiritualized")
        XCTAssertNil(nowNext.next)
    }

    func testThursday_farOut_afterLast() throws {
        mockDateFactory.setCurrentDate("17.08.2023 23:55")

        let nowNext = dataRepository.nowNext(for: .farOut)
        XCTAssertNil(nowNext)
    }

    func testFriday_mountain() throws {
        mockDateFactory.setCurrentDate("18.08.2023 15:30")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .mountain))
        let next = try XCTUnwrap(nowNext.next)
        XCTAssertFalse(nowNext.isNowStarted)
        XCTAssertEqual(nowNext.now.name, "Dur-Dur Band Int.")
        XCTAssertEqual(next.name, "Beth Orton")
    }
}

private extension DataRepository {
    func nowNext(for stage: GMStage) -> NowNext? {
        nowNext(for: stage.identifier)
    }
}
