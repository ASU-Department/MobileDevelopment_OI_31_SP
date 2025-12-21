import UIKit
import SwiftUI

class ReviewsViewController: UIViewController {

    let eventTitle: String

    init(eventTitle: String) {
        self.eventTitle = eventTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let titleLabel = UILabel()
        titleLabel.text = "Відгуки з попередніх міст"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = eventTitle
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        let reviewsStack = UIStackView()
        reviewsStack.axis = .vertical
        reviewsStack.spacing = 16

        reviewsStack.addArrangedSubview(makeReview(
            stars: "★★★★★",
            author: "Олена, Київ",
            text: "Дуже атмосферна подія, неймовірна дискусія."
        ))

        reviewsStack.addArrangedSubview(makeReview(
            stars: "★★★★☆",
            author: "Андрій, Харків",
            text: "Цікаво, але трохи затягнуто."
        ))

        reviewsStack.addArrangedSubview(makeReview(
            stars: "★★★★★",
            author: "Марта, Рівне",
            text: "Піду ще раз без сумнівів!"
        ))

        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            reviewsStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func makeReview(stars: String, author: String, text: String) -> UIView {
        let starsLabel = UILabel()
        starsLabel.text = stars

        let authorLabel = UILabel()
        authorLabel.text = author
        authorLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        let textLabel = UILabel()
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            starsLabel,
            authorLabel,
            textLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4

        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 12

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])

        return container
    }
}

struct ReviewsViewControllerWrapper: UIViewControllerRepresentable {

    let eventTitle: String

    func makeUIViewController(context: Context) -> ReviewsViewController {
        ReviewsViewController(eventTitle: eventTitle)
    }

    func updateUIViewController(_ uiViewController: ReviewsViewController, context: Context) {}
}
