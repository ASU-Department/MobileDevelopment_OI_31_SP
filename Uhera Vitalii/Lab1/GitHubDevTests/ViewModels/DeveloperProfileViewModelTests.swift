//
//  DeveloperProfileViewModelTests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//


import Testing
@testable import Lab1

@MainActor
struct DeveloperProfileViewModelTests {

    @Test("Initializes with provided profile")
    func initializesCorrectly() {
        let dev = TestDataFactory.developer()
        let sut = DeveloperProfileViewModel(profile: dev)

        #expect(sut.profile.username == dev.username)
    }

    @Test("Profile data remains immutable unless replaced")
    func profileIsStable() {
        let dev = TestDataFactory.developer(username: "octocat")
        let sut = DeveloperProfileViewModel(profile: dev)

        #expect(sut.profile.username == "octocat")
    }
}
