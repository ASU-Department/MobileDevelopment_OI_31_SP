//
//  AddHabitViewModelTests.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import XCTest
@testable import habitBuddy

@MainActor
final class AddHabitViewModelTests: XCTestCase {

    private var mockRepository: MockHabitRepository!
    private var viewModel: AddHabitViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockHabitRepository()
        viewModel = AddHabitViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testSaveHabitEmptyNameSetsErrorMessage() {
        // GIVEN
        viewModel.name = "   "
        viewModel.desc = "Some description"

        // WHEN
        viewModel.saveHabit { }

        // THEN
        XCTAssertEqual(viewModel.errorMessage, "Name cannot be empty")
        XCTAssertFalse(mockRepository.addCalled)
    }

    func testSaveHabitValidInputCallsRepositoryAndClearsError() async {
        // GIVEN
        viewModel.name = "Read books"
        viewModel.desc = "30 minutes every day"

        let expectation = XCTestExpectation(description: "onSuccess called")

        // WHEN
        viewModel.saveHabit {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(mockRepository.addCalled)
        XCTAssertEqual(mockRepository.habits.count, 1)
        XCTAssertEqual(mockRepository.habits.first?.name, "Read books")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSaveHabitRepositoryFailureSetsErrorMessage() async {
        // GIVEN
        mockRepository.shouldThrowError = true
        viewModel.name = "Workout"
        viewModel.desc = "Gym session"

        let expectation = XCTestExpectation(description: "async task finished")

        // WHEN
        viewModel.saveHabit {
            XCTFail("onSuccess should NOT be called on failure")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(mockRepository.addCalled)
        XCTAssertEqual(viewModel.errorMessage, "Failed to save habit")
        XCTAssertTrue(mockRepository.habits.isEmpty)
    }

    func testSaveHabitRepositoryErrorDoesNotCallOnSuccess() async {
        // GIVEN
        mockRepository.shouldThrowError = true
        viewModel.name = "Sleep"
        viewModel.desc = "8 hours"

        var successCalled = false

        // WHEN
        viewModel.saveHabit {
            successCalled = true
        }

        try? await Task.sleep(nanoseconds: 100_000_000)

        // THEN
        XCTAssertTrue(mockRepository.addCalled)
        XCTAssertFalse(successCalled)
        XCTAssertEqual(viewModel.errorMessage, "Failed to save habit")
    }
}
