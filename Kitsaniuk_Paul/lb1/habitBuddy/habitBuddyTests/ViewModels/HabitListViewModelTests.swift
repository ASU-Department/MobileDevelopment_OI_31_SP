//
//  HabitListViewModelTests.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import XCTest
@testable import habitBuddy

@MainActor
final class HabitListViewModelTests: XCTestCase {

    private var mockRepository: MockHabitRepository!
    private var viewModel: HabitListViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockHabitRepository()
        viewModel = HabitListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testInitialStateIsEmptyAndNotLoading() {
        XCTAssertTrue(viewModel.habits.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadHabitsSuccessSetsHabits() async {
        // GIVEN
        mockRepository.habits = [
            Habit(name: "Read"),
            Habit(name: "Workout")
        ]

        // WHEN
        await viewModel.loadHabits()

        // THEN
        XCTAssertTrue(mockRepository.fetchCalled)
        XCTAssertEqual(viewModel.habits.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadHabitsFailureSetsErrorMessage() async {
        // GIVEN
        mockRepository.shouldThrowError = true

        // WHEN
        await viewModel.loadHabits()

        // THEN
        XCTAssertTrue(viewModel.habits.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load habits")
    }

    func testDeleteHabitCallsRepositoryAndReloads() async {
        // GIVEN
        let habit = Habit(name: "Meditate")
        mockRepository.habits = [habit]

        await viewModel.loadHabits()
        XCTAssertEqual(viewModel.habits.count, 1)

        // WHEN
        viewModel.deleteHabit(habit)

        try? await Task.sleep(nanoseconds: 200_000_000)

        // THEN
        XCTAssertTrue(mockRepository.deleteCalled)
        XCTAssertTrue(mockRepository.fetchCalled)
    }
}
