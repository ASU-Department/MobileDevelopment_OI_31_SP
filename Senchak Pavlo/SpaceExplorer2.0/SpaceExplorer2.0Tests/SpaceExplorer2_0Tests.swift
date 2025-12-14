//
//  HomeViewModelTests.swift
//  SpaceExplorer2.0Tests
//
//  Created by Pab1m on 14.12.2025.

import XCTest
@testable import SpaceExplorer2_0

@MainActor
final class HomeViewModelTests2: XCTestCase {

    func testLoadAPODSuccess() async {
        let mockRepo = MockAPODRepository()
        let testAPOD = APODResponse(
            title: "Test APOD",
            explanation: "Test explanation",
            url: "https://test.com/image.jpg",
            media_type: "image"
        )

        mockRepo.result = .success(testAPOD)

        let viewModel = HomeViewModel(repository: mockRepo)

        await viewModel.loadAPOD()

        XCTAssertNotNil(viewModel.apod)
        XCTAssertEqual(viewModel.apod?.title, "Test APOD")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadAPODFailure() async {
        let mockRepo = MockAPODRepository()
        mockRepo.result = .failure(URLError(.notConnectedToInternet))

        let viewModel = HomeViewModel(repository: mockRepo)

        await viewModel.loadAPOD()

        XCTAssertNil(viewModel.apod)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    // Advanced
    func testLoadAPODWithDelay_setsLoadingStateCorrectly() async {
        let mockRepo = MockAPODRepository()
        let testAPOD = APODResponse(
            title: "Delayed APOD",
            explanation: "Test",
            url: "https://example.com",
            media_type: "image"
        )

        mockRepo.result = .delayed(testAPOD, 500_000_000)

        let viewModel = HomeViewModel(repository: mockRepo)

        let task = Task {
            await viewModel.loadAPOD()
        }

        await Task.yield()

        XCTAssertTrue(viewModel.isLoading)

        await task.value

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.apod?.title, "Delayed APOD")
    }
}
