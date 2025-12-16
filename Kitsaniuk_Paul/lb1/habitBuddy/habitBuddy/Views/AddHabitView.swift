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
                    TextField("Description", text: $viewModel.desc)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
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
