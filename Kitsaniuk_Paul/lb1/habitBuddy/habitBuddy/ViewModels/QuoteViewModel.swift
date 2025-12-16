//
//  QuoteViewModel.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

@MainActor
final class QuoteViewModel: ObservableObject {

    @Published var quoteText: String = "Loading quote..."
    @Published var isLoading: Bool = false

    private let repository: QuoteRepository

    init(repository: QuoteRepository) {
        self.repository = repository
    }

    func loadQuote() async {
        isLoading = true
        let quote = await repository.getQuote()
        quoteText = quote.text
        isLoading = false
    }
}
