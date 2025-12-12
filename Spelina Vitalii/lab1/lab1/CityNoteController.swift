//
//  CityNoteController.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI
import UIKit

struct CityNoteController: UIViewControllerRepresentable {
    @Binding var note: String

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground

        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter note"
        textField.text = note
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])

        return vc
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CityNoteController
        init(parent: CityNoteController) { self.parent = parent }

        @objc func textChanged(_ sender: UITextField) {
            parent.note = sender.text ?? ""
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let textField = uiViewController.view.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.text = note
        }
    }
}

