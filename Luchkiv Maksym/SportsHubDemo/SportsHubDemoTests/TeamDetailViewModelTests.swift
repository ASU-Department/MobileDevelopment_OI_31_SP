import XCTest
@testable import SportsHubDemo

@MainActor
final class TeamDetailViewModelTests: XCTestCase {
    func testDefaultsUseSeasonScope() async {
        let viewModel = TeamDetailViewModel(team: SampleData.warriors)

        XCTAssertEqual(viewModel.selectedScopeIndex, 1)
        XCTAssertEqual(viewModel.currentScope, .season)
        XCTAssertFalse(viewModel.playerStats.isEmpty)
    }

    func testChangingScopeUpdatesCurrentScope() async {
        let viewModel = TeamDetailViewModel(team: SampleData.lakers)

        viewModel.selectedScopeIndex = 0
        XCTAssertEqual(viewModel.currentScope, .last10)
        viewModel.selectedScopeIndex = 1
        XCTAssertEqual(viewModel.currentScope, .season)
    }
}
