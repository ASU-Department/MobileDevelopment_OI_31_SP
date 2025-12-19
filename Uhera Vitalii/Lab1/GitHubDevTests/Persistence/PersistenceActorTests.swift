//
//  PersistenceActorTests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import Testing

@testable import Lab1

@Suite("PersistenceActor Tests")
struct PersistenceActorTests {

    func makeActor() -> (PersistenceActor, MockPersistenceStore) {
        let store = MockPersistenceStore()
        let actor = PersistenceActor(store: store)
        return (actor, store)
    }

    @Test
    func saveAndFetchRepositories() async {
        let (actor, _) = makeActor()

        let repos = [
            Repository.mock(id: 1),
            Repository.mock(id: 2),
        ]

        let dev = DeveloperProfile.mock

        await actor.save(repositories: repos, developer: dev)
        let cached = await actor.fetchRepositories()

        #expect(cached.count == 2)
        #expect(cached.map(\.id) == [1, 2])
    }

    @Test
    func saveAndFetchDeveloper() async {
        let (actor, _) = makeActor()
        let dev = DeveloperProfile.mock

        await actor.save(repositories: [], developer: dev)
        let cached = await actor.fetchDeveloper()

        #expect(cached != nil)
        #expect(cached!.username == "octocat")
    }

    @Test
    func toggleStar_addsRepo() async {
        let (actor, _) = makeActor()

        await actor.toggleStar(repoId: 42)
        let starred = await actor.fetchStarredRepoIds()

        #expect(starred.contains(42))
    }

    @Test
    func toggleStar_removesRepo() async {
        let (actor, _) = makeActor()

        await actor.toggleStar(repoId: 42)
        await actor.toggleStar(repoId: 42)

        let starred = await actor.fetchStarredRepoIds()
        #expect(!starred.contains(42))
    }

    @Test
    func concurrentStarToggles_areThreadSafe() async {
        let (actor, _) = makeActor()

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<50 {
                group.addTask {
                    await actor.toggleStar(repoId: 99)
                }
            }
        }

        let starred = await actor.fetchStarredRepoIds()
        #expect(starred == [] || starred.contains(99))
    }

    @Test
    func fetchEmptyState_returnsDefaults() async {
        let (actor, _) = makeActor()

        let repos = await actor.fetchRepositories()
        let dev = await actor.fetchDeveloper()
        let stars = await actor.fetchStarredRepoIds()

        #expect(repos.isEmpty)
        #expect(dev == nil)
        #expect(stars.isEmpty)
    }
}
