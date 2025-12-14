//
//  AddHabitViewModel.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

@MainActor
final class AddHabitViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var desc: String = ""
    @Published var errorMessage: String?

    private let repository: HabitRepositoryProtocol

    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }

    func saveHabit(onSuccess: @escaping () -> Void) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }

        Task {
            do {
                try await repository.addHabit(name: name, desc: desc)
                onSuccess()
            } catch {
                errorMessage = "Failed to save habit"
            }
        }
    }
}
