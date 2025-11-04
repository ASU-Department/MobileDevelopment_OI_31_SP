//
//  AddHabitView.swift
//  habitBuddy
//

import SwiftUI
import UIKit

// MARK: - UIKit Controller
class AddHabitViewController: UIViewController {
    var onSave: ((Habit) -> Void)?
    
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
        onSave?(newHabit)
        dismiss(animated: true)
    }
}

// MARK: - SwiftUI Wrapper
struct AddHabitView: UIViewControllerRepresentable {
    var onSave: (Habit) -> Void
    
    func makeUIViewController(context: Context) -> AddHabitViewController {
        let vc = AddHabitViewController()
        vc.onSave = onSave
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AddHabitViewController, context: Context) {}
}
