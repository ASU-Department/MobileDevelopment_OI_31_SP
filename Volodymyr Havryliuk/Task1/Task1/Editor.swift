//
//  Editor.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import UIKit
import SwiftUI
import Combine

@MainActor
final class BookFormViewModel: ObservableObject {
    @Published var title: String
    @Published var author: String
    @Published var desc: String
    @Published var rating: Float
    @Published var notes: String
    
    private let book: Book
    
    init(book: Book) {
        self.book = book
        self.title = book.title
        self.author = book.author
        self.desc = book.desc
        self.rating = book.rating
        self.notes = book.notes
    }
    
    func didUpdateData(
        title: String,
        author: String,
        desc: String,
        notes: String,
        rating: Float
    ) {
        // Update VM state
        self.title = title
        self.author = author
        self.desc = desc
        self.notes = notes
        self.rating = rating
        
        // Persist to the model (data persistence coordination in VM)
        book.title = title
        book.author = author
        book.desc = desc
        book.notes = notes
        book.rating = rating
    }
}

struct BookFormView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: BookFormViewModel
    
    func makeUIViewController(context: Context) -> BookFormViewController {
        let vc = BookFormViewController()
        vc.currentTitle = viewModel.title
        vc.currentAuthor = viewModel.author
        vc.currentDesc = viewModel.desc
        vc.currentRating = viewModel.rating
        vc.currentNotes = viewModel.notes
        
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(
        _ uiViewController: BookFormViewController,
        context: Context
    ) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }
    
    class Coordinator: NSObject, BookFormDelegate {
        let viewModel: BookFormViewModel
        init(viewModel: BookFormViewModel) { self.viewModel = viewModel }
        
        func didUpdateData(
            title: String,
            author: String,
            desc: String,
            notes: String,
            rating: Float
        ) {
            viewModel.didUpdateData(
                title: title,
                author: author,
                desc: desc,
                notes: notes,
                rating: rating
            )
        }
    }
}

protocol BookFormDelegate: AnyObject {
    func didUpdateData(
        title: String,
        author: String,
        desc: String,
        notes: String,
        rating: Float
    )
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
        let tf = UITextField()
        tf.placeholder = "Book Title"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let authorField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Author"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let descLabel: UILabel = {
        let l = UILabel()
        l.text = "Description"
        l.font = .boldSystemFont(ofSize: 14)
        return l
    }()
    
    private let descTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 6
        tv.font = .systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let ratingLabel = UILabel()
    
    private let ratingSlider: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 5
        return s
    }()
    
    private let notesLabel: UILabel = {
        let l = UILabel()
        l.text = "Notes"
        l.font = .boldSystemFont(ofSize: 14)
        return l
    }()
    
    private let notesTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 6
        tv.font = .systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
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
            scrollView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),
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
        let stack = UIStackView(
            arrangedSubviews: [
                UILabel(text: "Title"), titleField,
                UILabel(text: "Author"), authorField,
                descLabel, descTextView,
                ratingLabel, ratingSlider,
                notesLabel, notesTextView
            ]
        )
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
            stack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            ) // Important for scroll content size
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
        ratingLabel.text = String(
            format: "Rating: %.1f / 5.0",
            ratingSlider.value
        )
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .boldSystemFont(ofSize: 14)
    }
}
