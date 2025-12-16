import XCTest
import SwiftData
@testable import SportsHubDemo

final class GameCacheActorTests: XCTestCase {
    func testSaveAndLoadRoundTrip() async throws {
        let container = try TestHelpers.makeInMemoryContainer()
        let actor = GameCacheActor(container: container)
        let dto = TestHelpers.makeBDLGame(status: "Final", homeScore: 80, awayScore: 90)

        await actor.save(apiGames: [dto])
        let games = await actor.loadGames()

        XCTAssertEqual(games.count, 1)
        XCTAssertEqual(games.first?.home.name, dto.home_team.name)
        XCTAssertEqual(games.first?.away.city, dto.visitor_team.city)
        XCTAssertFalse(games.first?.isLive ?? true)
    }

    func testSaveReplacesExistingRecords() async throws {
        let container = try TestHelpers.makeInMemoryContainer()
        let actor = GameCacheActor(container: container)
        let first = TestHelpers.makeBDLGame(id: 1, status: "Final", homeScore: 99, awayScore: 95)
        let replacement = TestHelpers.makeBDLGame(id: 2, status: "In Progress", homeScore: 50, awayScore: 52)

        await actor.save(apiGames: [first])
        await actor.save(apiGames: [replacement])

        let games = await actor.loadGames()
        XCTAssertEqual(games.count, 1)
        XCTAssertEqual(games.first?.homeScore, 50)
        XCTAssertEqual(games.first?.awayScore, 52)
        XCTAssertTrue(games.first?.isLive ?? false)
    }

    func testLoadWhileSavingReturnsConsistentSnapshot() async throws {
        let container = try TestHelpers.makeInMemoryContainer()
        let actor = GameCacheActor(container: container)
        let initial = TestHelpers.makeBDLGame(id: 1, status: "Final", homeScore: 70, awayScore: 68)
        await actor.save(apiGames: [initial])

        let expectation = expectation(description: "Concurrent save completes")
        Task.detached {
            await actor.save(apiGames: [TestHelpers.makeBDLGame(id: 3, status: "In Progress", homeScore: 5, awayScore: 4)])
            expectation.fulfill()
        }

        let snapshot = await actor.loadGames()
        XCTAssertFalse(snapshot.isEmpty)
        wait(for: [expectation], timeout: 2.0)
        let final = await actor.loadGames()
        XCTAssertEqual(final.count, 1)
    }
}
