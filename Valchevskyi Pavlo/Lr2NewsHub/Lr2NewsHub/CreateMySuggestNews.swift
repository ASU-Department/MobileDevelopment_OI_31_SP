//
//  CreateMySuggestNews.swift
//  Lr2NewsHub
//

import SwiftUI
import UIKit

class SuggestArticleViewController: UIViewController {
    var onClickButton: ((Article) -> Void)?
    
    let titleLabel = UILabel()
    let titleField = UITextField()
    
    let textLabel = UILabel()
    let textField = UITextView()
    
    let suggestButton = UIButton(type: .system)

    @objc private func clickButton() {
        guard let title = titleField.text, !title.isEmpty,
              let text = textField.text, !text.isEmpty else {
            return
        }
        let newArticle = Article(title: title, text: text, category: "My suggest news")
        onClickButton?(newArticle)
    }
    
    func makeUI() {
        titleLabel.text = "Enter title article:"
        titleLabel.textColor = .black
        titleField.layer.borderWidth = 1
        
        textLabel.text = "Enter text article:"
        textLabel.textColor = .black
        textField.layer.borderWidth = 1
        textField.font = titleField.font
        
        suggestButton.setTitle("Suggest Article", for: .normal)
        suggestButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, titleField, textLabel, textField, suggestButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300),
            titleField.heightAnchor.constraint(equalToConstant: 35),
            textField.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeUI()
    }
}

struct CreateMySuggestArticle: UIViewControllerRepresentable {
    var onClickButton: (Article) -> Void
    
    func makeUIViewController(context: Context) -> SuggestArticleViewController {
        let vc = SuggestArticleViewController()
        vc.onClickButton = onClickButton
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SuggestArticleViewController, context: Context) {}
}

#Preview {
    CreateMySuggestArticle { newArticle in }
}
