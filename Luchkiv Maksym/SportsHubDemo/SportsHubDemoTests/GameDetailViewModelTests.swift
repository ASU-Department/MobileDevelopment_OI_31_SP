import XCTest
@testable import SportsHubDemo

@MainActor
final class GameDetailViewModelTests: XCTestCase {
    func testShareTextIncludesScoresAndPrediction() {
        let game = SampleData.games[0]
        let viewModel = GameDetailViewModel(game: game, isFavoriteHome: true, isFavoriteAway: false)
        viewModel.predictedHomeMargin = 12

        let text = viewModel.shareText
        XCTAssertTrue(text.contains(game.home.name))
        XCTAssertTrue(text.contains(game.away.name))
        XCTAssertTrue(text.contains("12"))
        XCTAssertTrue(text.contains(game.statusText))
    }

    func testShareSheetFlagToggles() {
        let viewModel = GameDetailViewModel(game: SampleData.games[1], isFavoriteHome: false, isFavoriteAway: false)

        XCTAssertFalse(viewModel.showShareSheet)
        viewModel.showShareSheet = true
        XCTAssertTrue(viewModel.showShareSheet)
    }
}
