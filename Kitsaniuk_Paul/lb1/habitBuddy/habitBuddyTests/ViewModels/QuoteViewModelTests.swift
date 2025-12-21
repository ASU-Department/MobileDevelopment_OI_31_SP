//
//  QuoteViewModelTests.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import XCTest
@testable import habitBuddy

@MainActor
final class QuoteViewModelTests: XCTestCase {

    private var mockRepository: MockQuoteRepository!
    private var viewModel: QuoteViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockQuoteRepository()
        viewModel = QuoteViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.quoteText, "Loading quote...")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadQuoteUpdatesQuoteText() async {
        // GIVEN
        let expected = "Stay consistent"
        mockRepository.quoteToReturn = Quote(text: expected)

        // WHEN
        await viewModel.loadQuote()

        // THEN
        XCTAssertTrue(mockRepository.getQuoteCalled)
        XCTAssertEqual(viewModel.quoteText, expected)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadQuoteWithEmptyQuoteSetsFallbackText() async {
        // GIVEN
        mockRepository.quoteToReturn = Quote(text: "")

        // WHEN
        await viewModel.loadQuote()

        // THEN
        XCTAssertEqual(viewModel.quoteText, "")
        XCTAssertFalse(viewModel.isLoading)
    }
}
