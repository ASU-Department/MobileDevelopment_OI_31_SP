//
//  MockQuoteRepository.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import Foundation
@testable import habitBuddy

final class MockQuoteRepository: QuoteRepositoryProtocol {

    var quoteToReturn: Quote = Quote(text: "Test quote")
    var getQuoteCalled = false
    var delay: UInt64 = 0

    func getQuote() async -> Quote {
        getQuoteCalled = true

        if delay > 0 {
            try? await Task.sleep(nanoseconds: delay)
        }

        return quoteToReturn
    }
}
