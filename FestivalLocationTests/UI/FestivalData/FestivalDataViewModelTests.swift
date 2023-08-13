import RealmSwift
import XCTest

@testable import FestivalLocation

final class FestivalDataViewModelTests: XCTestCase {
    private var dataRepository: DataRepository!
    private var dataLoader: FileDataLoader!
    private var viewModel: FestivalDataViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let config = Realm.Configuration(inMemoryIdentifier: "FestivalDataViewModelTests")
        let realm = try Realm(configuration: config)
        dataRepository = RealmDataRepository(realm: realm)
        dataLoader = FileDataLoader(fileName: "GreenMan2023.txt", dataRepository: dataRepository)
        viewModel = .init(dataRepository: dataRepository, dataLoader: dataLoader)
    }

    override func tearDownWithError() throws {
        dataRepository = nil
        dataLoader = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInitialData() {
        XCTAssertEqual(viewModel.numberOfSlots, 5)
    }

    func testSundayTwist() {
        viewModel.selectedDay = .sunday
        viewModel.selectedStage = .roundTheTwist

        XCTAssertEqual(viewModel.numberOfSlots, 6)
    }
}
