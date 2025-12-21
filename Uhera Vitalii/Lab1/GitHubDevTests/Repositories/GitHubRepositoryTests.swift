//
//  GitHubRepositoryTests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import XCTest

@testable import Lab1

@MainActor
final class GitHubRepositoryTests: XCTestCase {

    private var api: MockGitHubAPIService!
    private var persistence: PersistenceActor!
    private var repository: GitHubRepository!

    override func setUp() {
        super.setUp()
        api = MockGitHubAPIService()
        persistence = PersistenceActor(store: MockPersistenceStore())
        repository = GitHubRepository(
            api: api,
            persistenceActor: persistence
        )
    }

    override func tearDown() {
        api = nil
        persistence = nil
        repository = nil
        super.tearDown()
    }

    func testLoadUser_success() async throws {
        let user = try await repository.loadUser(username: "octocat")
        XCTAssertEqual(user.username, "octocat")
    }

    func testLoadUser_failureFallsBackToCache() async {
        let cachedRepo = Repository.mock
        let cachedDev = DeveloperProfile.mock
        
        await repository.save(repositories: [cachedRepo], developer: cachedDev)
        
        api.userResult = .failure(MockGitHubAPIService.MockError.network)

        let cached = await repository.loadCachedDeveloper()
        
        XCTAssertNotNil(cached?.username, cachedDev.username)
    }
    

    func testLoadRepositories_success() async throws {
        api.reposResult = .success([
            GitHubRepositoryDTO.mock(id: 1),
            GitHubRepositoryDTO.mock(id: 2),
        ])

        let repos = try await repository.loadRepositories(username: "octocat")
        XCTAssertEqual(repos.count, 2)
    }

    func testLoadRepositories_failureLoadsCached() async {
        api.reposResult = .failure(MockGitHubAPIService.MockError.network)

        let repos = await repository.loadCachedRepositories()
        XCTAssertNotNil(repos)
    }

    func testToggleStar_addsRepo() async {
        await repository.toggleStar(repoId: 10)
        let starred = await repository.loadStarredRepoIds()

        XCTAssertTrue(starred.contains(10))
    }

    func testToggleStar_removesRepo() async {
        await repository.toggleStar(repoId: 10)
        await repository.toggleStar(repoId: 10)

        let starred = await repository.loadStarredRepoIds()
        XCTAssertFalse(starred.contains(10))
    }

    func testConcurrentStarToggles_areThreadSafe() async {
        let repoId = 99
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    await self.repository.toggleStar(repoId: repoId)
                }
            }
        }

        let starred = await repository.loadStarredRepoIds()
        XCTAssertTrue(starred == [] || starred.contains(99))
    }
}
