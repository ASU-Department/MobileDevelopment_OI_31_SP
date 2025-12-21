//
//  AddHabitView.swift
//  habitBuddy
//

import SwiftUI

struct AddHabitView: View {

    @ObservedObject var viewModel: AddHabitViewModel
    @Environment(\.dismiss) private var dismiss

    let onSaved: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                        .accessibilityIdentifier("addHabitNameField")
                    TextField("Description", text: $viewModel.desc)
                        .accessibilityIdentifier("addHabitDescField")
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .accessibilityIdentifier("addHabitErrorText")
                }
            }
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveHabit {
                            onSaved()
                            dismiss()
                        }
                    }
                    .accessibilityIdentifier("addHabitSaveButton")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
