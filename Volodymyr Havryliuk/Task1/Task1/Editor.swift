//
//  Editor.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import UIKit
import SwiftUI

struct BookFormView: UIViewControllerRepresentable {
    @Binding var book: Book
    
    func makeUIViewController(context: Context) -> BookFormViewController {
        let vc = BookFormViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: BookFormViewController, context: Context) {
        uiViewController.updateUI(with: book)
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, BookFormDelegate {
        var parent: BookFormView
        init(_ parent: BookFormView) { self.parent = parent }
        func didUpdateData(title: String, notes: String, rating: Float) {
            parent.book.title = title
            parent.book.notes = notes
            parent.book.rating = rating
        }
    }
}

protocol BookFormDelegate: AnyObject {
    func didUpdateData(title: String, notes: String, rating: Float)
}

class BookFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    weak var delegate: BookFormDelegate?
    
    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Book Title"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let ratingSlider: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 5
        return s
    }()
    
    private let ratingLabel = UILabel()
    private let notesLabel = UILabel()
    
    private let notesTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 6
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        titleField.addTarget(self, action: #selector(changed), for: .editingChanged)
        ratingSlider.addTarget(self, action: #selector(changed), for: .valueChanged)
        notesTextView.delegate = self
    }
    
    private func setupLayout() {
        notesLabel.text = "Notes"
        let stack = UIStackView(arrangedSubviews: [titleField, ratingLabel, ratingSlider, notesLabel, notesTextView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func updateUI(with book: Book) {
        if titleField.text != book.title { titleField.text = book.title }
        if abs(ratingSlider.value - book.rating) > 0.1 { ratingSlider.value = book.rating }
        if notesTextView.text != book.notes { notesTextView.text = book.notes }
        updateLabel()
    }
    
    @objc func changed() { report() }
    func textViewDidChange(_ textView: UITextView) { report() }
    private func report() {
        updateLabel()
        delegate?.didUpdateData(title: titleField.text ?? "", notes: notesTextView.text, rating: ratingSlider.value)
    }
    
    private func updateLabel() { ratingLabel.text = String(format: "Rating: %.1f / 5.0", ratingSlider.value) }
}
