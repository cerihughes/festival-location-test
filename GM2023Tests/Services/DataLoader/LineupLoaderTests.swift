import RealmSwift
import XCTest

@testable import GM2023

final class LineupLoaderTests: XCTestCase {
    private var dataRepository: DataRepository!
    private var lineupLoader: LineupLoader!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let config = Realm.Configuration(inMemoryIdentifier: "LineupLoaderTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)

        lineupLoader = DefaultLineupLoader(dataRepository: dataRepository)
        XCTAssertTrue(lineupLoader.importLineup(loader: .fileName(.greenMan2023FestivalLineup)))
    }

    override func tearDownWithError() throws {
        dataRepository = nil
        lineupLoader = nil
        try super.tearDownWithError()
    }

    func testImport() throws {
        let festival = try XCTUnwrap(dataRepository.festival(name: .greenMan2023FestivalName))
        let stageNames = festival.stages.map { $0.name }
        XCTAssertEqual(stageNames.count, 8)
        XCTAssertTrue(stageNames.contains("Mountain Stage"))
        XCTAssertTrue(stageNames.contains("Far Out"))
        XCTAssertTrue(stageNames.contains("Walled Garden"))
        XCTAssertTrue(stageNames.contains("Rising"))
        XCTAssertTrue(stageNames.contains("Chai Wallahs"))
        XCTAssertTrue(stageNames.contains("Babbling Tongues"))
        XCTAssertTrue(stageNames.contains("Cinedrome"))
        XCTAssertTrue(stageNames.contains("Round The Twist"))
    }

    func testOrdering() throws {
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
            "TBA",
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
            "Belinduh Belinduh Belinduh",
            "Spank DJs"
        ])
    }

    func testMidnightOverlaps() throws {
        let dateFormatter = DateFormatter.dd_MM_yyyy_HH_mm()
        let festival = try XCTUnwrap(dataRepository.festival(name: .greenMan2023FestivalName))
        let stage1 = try XCTUnwrap(dataRepository.getOrCreateStage(in: festival, name: "Chai Wallahs"))
        let stage2 = try XCTUnwrap(dataRepository.getOrCreateStage(in: festival, name: "Round The Twist"))

        let sortedSlots1 = stage1.slots.sorted(by: \.start)
        let sortedSlots2 = stage2.slots.sorted(by: \.start)

        let startBeforeEndOn = try XCTUnwrap(sortedSlots1[safe: 6])
        let startOnEndAfter = try XCTUnwrap(sortedSlots1[safe: 7])
        let startAfterEndAfter = try XCTUnwrap(sortedSlots1[safe: 18])
        let startBeforeEndAfter = try XCTUnwrap(sortedSlots2[safe: 5])

        assertSlot(
            startBeforeEndOn,
            hasName: "TC & the Groove Family",
            expectedStartDate: "17.08.2023 22:45",
            expectedEndDate: "18.08.2023 00:00",
            dateFormatter: dateFormatter
        )

        assertSlot(
            startOnEndAfter,
            hasName: "Diplomats Of Sound DJs",
            expectedStartDate: "18.08.2023 00:00",
            expectedEndDate: "18.08.2023 02:00",
            dateFormatter: dateFormatter
        )

        assertSlot(
            startAfterEndAfter,
            hasName: "Diplomats Of Sound DJs",
            expectedStartDate: "19.08.2023 01:00",
            expectedEndDate: "19.08.2023 04:00",
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
