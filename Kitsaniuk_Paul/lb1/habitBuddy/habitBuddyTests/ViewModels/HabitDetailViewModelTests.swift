//
//  HabitDetailViewModelTests.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import XCTest
@testable import habitBuddy

@MainActor
final class HabitDetailViewModelTests: XCTestCase {

    private var mockRepository: MockHabitRepository!
    private var habit: Habit!
    private var viewModel: HabitDetailViewModel!

    override func setUp() {
        super.setUp()

        mockRepository = MockHabitRepository()
        habit = Habit(name: "Read", desc: "Read books", streak: 3)

        viewModel = HabitDetailViewModel(
            habit: habit,
            repository: mockRepository
        )
    }

    override func tearDown() {
        mockRepository = nil
        habit = nil
        viewModel = nil
        super.tearDown()
    }

    func testInitialStateIsTakenFromHabit() {
        XCTAssertEqual(viewModel.name, "Read")
        XCTAssertEqual(viewModel.desc, "Read books")
        XCTAssertEqual(viewModel.streak, 3)
        XCTAssertEqual(viewModel.importance, 50)
    }

    func testEditingFieldsUpdatesViewModelState() {
        // WHEN
        viewModel.name = "Workout"
        viewModel.desc = "Gym"
        viewModel.streak = 10

        // THEN
        XCTAssertEqual(viewModel.name, "Workout")
        XCTAssertEqual(viewModel.desc, "Gym")
        XCTAssertEqual(viewModel.streak, 10)
    }

    func testSaveChangesUpdatesHabitAndCallsRepository() async {
        // GIVEN
        viewModel.name = "Meditation"
        viewModel.desc = "Morning routine"
        viewModel.streak = 7

        // WHEN
        viewModel.saveChanges()

        try? await Task.sleep(nanoseconds: 50_000_000)

        // THEN
        XCTAssertTrue(mockRepository.updateCalled)

        XCTAssertEqual(habit.name, "Meditation")
        XCTAssertEqual(habit.desc, "Morning routine")
        XCTAssertEqual(habit.streak, 7)
    }
    
    func testSaveChangesRepositoryFailureDoesNotCrash() async {
        // GIVEN
        mockRepository.shouldThrowError = true

        viewModel.name = "Fail case"
        viewModel.desc = "Desc"
        viewModel.streak = 99

        // WHEN
        viewModel.saveChanges()

        try? await Task.sleep(nanoseconds: 100_000_000)

        // THEN
        XCTAssertTrue(mockRepository.updateCalled)

        XCTAssertEqual(viewModel.name, "Fail case")
        XCTAssertEqual(viewModel.streak, 99)
    }
}
