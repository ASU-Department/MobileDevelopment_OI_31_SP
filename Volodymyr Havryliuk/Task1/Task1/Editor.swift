//
//  Editor.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import UIKit
import SwiftUI

struct BookFormView: UIViewControllerRepresentable {
    @Bindable var book: Book
    
    func makeUIViewController(context: Context) -> BookFormViewController {
        let vc = BookFormViewController()
        vc.currentTitle = book.title
        vc.currentAuthor = book.author
        vc.currentDesc = book.desc
        vc.currentRating = book.rating
        vc.currentNotes = book.notes
        
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: BookFormViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, BookFormDelegate {
        var parent: BookFormView
        init(_ parent: BookFormView) { self.parent = parent }
        
        func didUpdateData(title: String, author: String, desc: String, notes: String, rating: Float) {
            parent.book.title = title
            parent.book.author = author
            parent.book.desc = desc
            parent.book.notes = notes
            parent.book.rating = rating
        }
    }
}

protocol BookFormDelegate: AnyObject {
    func didUpdateData(title: String, author: String, desc: String, notes: String, rating: Float)
}

class BookFormViewController: UIViewController, UITextViewDelegate {
    weak var delegate: BookFormDelegate?
    
    var currentTitle = ""
    var currentAuthor = ""
    var currentDesc = ""
    var currentRating: Float = 0.0
    var currentNotes = ""
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleField: UITextField = {
        let tf = UITextField(); tf.placeholder = "Book Title"; tf.borderStyle = .roundedRect; return tf
    }()
    
    private let authorField: UITextField = {
        let tf = UITextField(); tf.placeholder = "Author"; tf.borderStyle = .roundedRect; return tf
    }()
    
    private let descLabel: UILabel = { let l = UILabel(); l.text = "Description"; l.font = .boldSystemFont(ofSize: 14); return l }()
    
    private let descTextView: UITextView = {
        let tv = UITextView(); tv.layer.borderColor = UIColor.systemGray4.cgColor; tv.layer.borderWidth = 1; tv.layer.cornerRadius = 6; tv.font = .systemFont(ofSize: 14); tv.isScrollEnabled = false; return tv
    }()
    
    private let ratingLabel = UILabel()
    
    private let ratingSlider: UISlider = {
        let s = UISlider(); s.minimumValue = 0; s.maximumValue = 5; return s
    }()
    
    private let notesLabel: UILabel = { let l = UILabel(); l.text = "Notes"; l.font = .boldSystemFont(ofSize: 14); return l }()
    
    private let notesTextView: UITextView = {
        let tv = UITextView(); tv.layer.borderColor = UIColor.systemGray4.cgColor; tv.layer.borderWidth = 1; tv.layer.cornerRadius = 6; tv.font = .systemFont(ofSize: 14); tv.isScrollEnabled = false; return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupLayout()
        setupInitialValues()
        
        titleField.addTarget(self, action: #selector(changed), for: .editingChanged)
        authorField.addTarget(self, action: #selector(changed), for: .editingChanged)
        ratingSlider.addTarget(self, action: #selector(changed), for: .valueChanged)
        descTextView.delegate = self
        notesTextView.delegate = self
        
        updateLabel()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            UILabel(text: "Title"), titleField,
            UILabel(text: "Author"), authorField,
            descLabel, descTextView,
            ratingLabel, ratingSlider,
            notesLabel, notesTextView
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Important for scroll content size
        ])
    }
    
    private func setupInitialValues() {
        titleField.text = currentTitle
        authorField.text = currentAuthor
        descTextView.text = currentDesc
        ratingSlider.value = currentRating
        notesTextView.text = currentNotes
    }
    
    @objc func changed() { report() }
    func textViewDidChange(_ textView: UITextView) { report() }
    
    private func report() {
        updateLabel()
        delegate?.didUpdateData(
            title: titleField.text ?? "",
            author: authorField.text ?? "",
            desc: descTextView.text,
            notes: notesTextView.text,
            rating: ratingSlider.value
        )
    }
    
    private func updateLabel() {
        ratingLabel.text = String(format: "Rating: %.1f / 5.0", ratingSlider.value)
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .boldSystemFont(ofSize: 14)
    }
}
