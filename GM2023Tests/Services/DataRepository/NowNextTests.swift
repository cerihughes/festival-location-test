import RealmSwift
import XCTest

@testable import GM2023

class NowNextTests: XCTestCase {
    private var mockDateFactory: MockDateFactory!
    private var dataRepository: DataRepository!
    private var timeFormatter: DateFormatter!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDateFactory = MockDateFactory()
        dateFactory = mockDateFactory

        let config = Realm.Configuration(inMemoryIdentifier: "NowNextTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)
        timeFormatter = .HH_mm()

        let lineupLoader = DefaultLineupLoader(dataRepository: dataRepository)
        XCTAssertTrue(lineupLoader.importLineup(loader: .fileName(.greenMan2023FestivalLineup)))
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

    func testThursday_walledGarden_afterLast() throws {
        mockDateFactory.setCurrentDate("17.08.2023 23:55")

        let nowNext = dataRepository.nowNext(for: .walledGarden)
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

    func testPendingNowNoNext() throws {
        mockDateFactory.setCurrentDate("17.08.2023 22:15")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .farOut))
        let body = generateBody(nowNext: nowNext)
        XCTAssertEqual(body.count, 1)
        XCTAssertEqual(body[0], "22:30: Spiritualized")
    }

    func testNowNoNext() throws {
        mockDateFactory.setCurrentDate("17.08.2023 22:45")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .farOut))
        let body = generateBody(nowNext: nowNext)
        XCTAssertEqual(body.count, 1)
        XCTAssertEqual(body[0], "Now: Spiritualized")
    }

    func testPendingNowAndNext() throws {
        mockDateFactory.setCurrentDate("17.08.2023 10:00")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .walledGarden))
        let body = generateBody(nowNext: nowNext)
        XCTAssertEqual(body.count, 2)
        XCTAssertEqual(body[0], "16:00: Aisha Vaughan")
        XCTAssertEqual(body[1], "17:15: The Gentle Good")
    }

    func testNowAndNext() throws {
        mockDateFactory.setCurrentDate("17.08.2023 17:00")

        let nowNext = try XCTUnwrap(dataRepository.nowNext(for: .chaiWallahs))
        let body = generateBody(nowNext: nowNext)
        XCTAssertEqual(body.count, 2)
        XCTAssertEqual(body[0], "Now: The Beatles Dub Club")
        XCTAssertEqual(body[1], "18:00: Little Thief")
    }

    private func generateBody(nowNext: NowNext) -> [String] {
        nowNext.body(timeFormatter: timeFormatter)
            .split(separator: "\n")
            .map(String.init)
    }
}

private extension DataRepository {
    func nowNext(for stage: GMStage) -> NowNext? {
        nowNext(for: stage.identifier)
    }
}
