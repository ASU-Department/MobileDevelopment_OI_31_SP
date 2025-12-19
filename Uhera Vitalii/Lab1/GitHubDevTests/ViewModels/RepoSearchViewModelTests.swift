//
//  RepoSearchViewModelTests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import Testing

@testable import Lab1

@MainActor
struct RepoSearchViewModelTests {

    // MARK: - Helpers

    func makeSUT(
        repos: [Repository] = [],
        developer: DeveloperProfile,
        starred: Set<Int> = [],
        shouldFail: Bool = false
    ) -> RepoSearchViewModel {

        let repository = MockGitHubRepository(
            repositories: repos,
            developer: developer,
            starredRepoIds: starred,
            shouldFail: shouldFail
        )

        let coordinator = MockAppCoordinator()

        return RepoSearchViewModel(
            repository: repository,
            coordinator: coordinator
        )
    }

    @Test("Loads repositories and developer successfully")
    func loadsRepositoriesSuccessfully() async {
        let repos = TestDataFactory.repositories()
        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev)

        await sut.load()

        #expect(sut.repositories.count == repos.count)
        #expect(sut.developer?.username == dev.username)
        #expect(sut.isOffline == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("Offline fallback loads cached data")
    func offlineFallbackLoadsCachedData() async {
        let cachedRepos = TestDataFactory.repositories()
        let cachedDev = TestDataFactory.developer()

        let sut = makeSUT(
            repos: cachedRepos,
            developer: cachedDev,
            shouldFail: true
        )

        await sut.load()

        #expect(sut.isOffline == true)
        #expect(sut.repositories.count == cachedRepos.count)
        #expect(sut.developer?.username == cachedDev.username)
        #expect(sut.errorMessage != nil)
    }

    @Test("Search text filters repositories by name")
    func searchFiltersByName() async {
        let repos = [
            TestDataFactory.repo(id: 1, name: "SwiftUIApp"),
            TestDataFactory.repo(id: 2, name: "KotlinApp"),
        ]

        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev)
        await sut.load()

        sut.searchText = "swift"

        #expect(sut.filteredRepositories.count == 1)
        #expect(sut.filteredRepositories.first?.name == "SwiftUIApp")
    }

    @Test("Starred filter shows only starred repositories")
    func starredFilterWorks() async {
        let repos = TestDataFactory.repositories()
        let starred: Set<Int> = [repos.first!.id]
        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev, starred: starred)
        await sut.load()

        sut.showOnlyStarred = true

        #expect(sut.filteredRepositories.count == 1)
        #expect(sut.filteredRepositories.first?.id == repos.first!.id)
    }

    @Test("Open issues filter removes repositories with zero issues")
    func openIssuesFilterWorks() async {
        let repos = [
            TestDataFactory.repo(id: 1, issues: 0),
            TestDataFactory.repo(id: 2, issues: 5),
        ]

        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev)
        await sut.load()

        sut.showOnlyWithIssues = true

        #expect(sut.filteredRepositories.count == 1)
        #expect(sut.filteredRepositories.first?.openIssuesCount == 5)
    }

    @Test("Sort by stars descending")
    func sortByStars() async {
        let repos = [
            TestDataFactory.repo(id: 1, stars: 5),
            TestDataFactory.repo(id: 2, stars: 50),
        ]

        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev)
        await sut.load()

        sut.sortMode = .stars

        #expect(sut.filteredRepositories.first?.stargazersCount == 50)
    }

    @Test("Sort alphabetically")
    func sortAlphabetically() async {
        let repos = [
            TestDataFactory.repo(id: 1, name: "Zoo"),
            TestDataFactory.repo(id: 2, name: "Alpha"),
        ]

        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: repos, developer: dev)
        await sut.load()

        sut.sortMode = .alphabet

        #expect(sut.filteredRepositories.first?.name == "Alpha")
    }

    @Test("Toggling star updates starred set")
    func toggleStarUpdatesState() async {
        let repo = TestDataFactory.repo(id: 42)
        let dev = TestDataFactory.developer()

        let sut = makeSUT(repos: [repo], developer: dev)

        await sut.load()
        #expect(!sut.isStarred(repo))

        sut.toggleStar(repo)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(sut.isStarred(repo))
    }
}
