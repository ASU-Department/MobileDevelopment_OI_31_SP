//
//  AddHabitView.swift
//  habitBuddy
//

import SwiftUI
import UIKit
import SwiftData

class AddHabitViewController: UIViewController {
    var modelContext: ModelContext?
    
    private let nameField = UITextField()
    private let descField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        nameField.placeholder = "Enter habit name"
        nameField.borderStyle = .roundedRect
        
        descField.placeholder = "Enter short description"
        descField.borderStyle = .roundedRect
        
        saveButton.setTitle("Save Habit", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [nameField, descField, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func saveTapped() {
        guard let name = nameField.text, !name.isEmpty else { return }
        let newHabit = Habit(name: name, desc: descField.text ?? "", streak: 0)
        if let ctx = modelContext {
            ctx.insert(newHabit)
            do {
                try ctx.save()
            } catch {
                print("Failed to save new habit: \(error)")
            }
        }
        dismiss(animated: true)
    }
}

struct AddHabitView: UIViewControllerRepresentable {
    var modelContext: ModelContext
    
    func makeUIViewController(context: Context) -> AddHabitViewController {
        let vc = AddHabitViewController()
        vc.modelContext = modelContext
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AddHabitViewController, context: Context) {}
}
