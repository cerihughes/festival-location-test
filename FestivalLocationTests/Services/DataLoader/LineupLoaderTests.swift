import RealmSwift
import XCTest

@testable import FestivalLocation

final class LineupLoaderTests: XCTestCase {
    private var dataRepository: DataRepository!
    private var lineupLoader: FileLineupLoader!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let config = Realm.Configuration(inMemoryIdentifier: "LineupLoaderTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)

        lineupLoader = FileLineupLoader(fileName: .greenMan2023FestivalLineup, dataRepository: dataRepository)
    }

    override func tearDownWithError() throws {
        dataRepository = nil
        lineupLoader = nil
        try super.tearDownWithError()
    }

    func testLoad() throws {
        XCTAssertTrue(lineupLoader.loadData())

        let festival = try XCTUnwrap(dataRepository.festival(name: .greenMan2023FestivalName))
        let stageNames = festival.stages.map { $0.name }
        XCTAssertEqual(stageNames.count, 6)
        XCTAssertTrue(stageNames.contains("Mountain Stage"))
        XCTAssertTrue(stageNames.contains("Far Out"))
        XCTAssertTrue(stageNames.contains("Walled Garden"))
        XCTAssertTrue(stageNames.contains("Rising"))
        XCTAssertTrue(stageNames.contains("Chai Wallahs"))
        XCTAssertTrue(stageNames.contains("Round The Twist"))
    }

    func testOrdering() throws {
        XCTAssertTrue(lineupLoader.loadData())

        let festival = try XCTUnwrap(dataRepository.festival(name: .greenMan2023FestivalName))
        let stage = try XCTUnwrap(dataRepository.getOrCreateStage(in: festival, name: "Round The Twist"))

        let slotNames = stage.slots
            .sorted(by: \.start)
            .map { $0.name }
        XCTAssertEqual(Array(slotNames), [
            "Stone Club DJs",
            "Moof Magazine",
            "Pet Deaths Disco",
            "James Endeacott",
            "The Social Soundsystem",
            "Lice b2b PVA",
            "Flying Mojito Bros",
            "Iko Cherie",
            "Postmen DJs",
            "Dutty Disco",
            "Celtic Floor Muscles",
            "Jamie Hombre",
            "Ash Workman",
            "Stephen Bass & Rob Leggat",
            "Kate Hutchinson",
            "Kuntessa",
            "Ash Kenazi",
            "Joanie",
            "Babymorocco",
            "Belinduh",
            "Spank DJs"
        ])
    }

    func testMidnightOverlaps() throws {
        XCTAssertTrue(lineupLoader.loadData())

        let dateFormatter = DateFormatter.dd_MM_yyyy_HH_mm()
        let festival = try XCTUnwrap(dataRepository.festival(name: .greenMan2023FestivalName))
        let stage1 = try XCTUnwrap(dataRepository.getOrCreateStage(in: festival, name: "Chai Wallahs"))
        let stage2 = try XCTUnwrap(dataRepository.getOrCreateStage(in: festival, name: "Round The Twist"))

        let sortedSlots1 = stage1.slots.sorted(by: \.start)
        let sortedSlots2 = stage2.slots.sorted(by: \.start)

        let startBeforeEndOn = try XCTUnwrap(sortedSlots1[safe: 4])
        let startOnEndAfter = try XCTUnwrap(sortedSlots1[safe: 5])
        let startAfterEndAfter = try XCTUnwrap(sortedSlots1[safe: 14])
        let startBeforeEndAfter = try XCTUnwrap(sortedSlots2[safe: 5])

        assertSlot(
            startBeforeEndOn,
            hasName: "Will & The People",
            expectedStartDate: "17.08.2023 23:00",
            expectedEndDate: "18.08.2023 00:00",
            dateFormatter: dateFormatter
        )

        assertSlot(
            startOnEndAfter,
            hasName: "TC & the Groove Family",
            expectedStartDate: "18.08.2023 00:00",
            expectedEndDate: "18.08.2023 01:05",
            dateFormatter: dateFormatter
        )

        assertSlot(
            startAfterEndAfter,
            hasName: "Hannabiell & the Midnight Blue Collective",
            expectedStartDate: "19.08.2023 00:30",
            expectedEndDate: "19.08.2023 01:30",
            dateFormatter: dateFormatter
        )

        assertSlot(
            startBeforeEndAfter,
            hasName: "Lice b2b PVA",
            expectedStartDate: "17.08.2023 23:30",
            expectedEndDate: "18.08.2023 01:00",
            dateFormatter: dateFormatter
        )
    }

    private func assertSlot(
        _ slot: Slot,
        hasName name: String,
        expectedStartDate: String,
        expectedEndDate: String,
        dateFormatter: DateFormatter,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let actualStartDate = dateFormatter.string(from: slot.start)
        let actualEndDate = dateFormatter.string(from: slot.end)

        XCTAssertEqual(name, slot.name, file: file, line: line)
        XCTAssertEqual(expectedStartDate, actualStartDate, file: file, line: line)
        XCTAssertEqual(expectedEndDate, actualEndDate, file: file, line: line)
    }
}
