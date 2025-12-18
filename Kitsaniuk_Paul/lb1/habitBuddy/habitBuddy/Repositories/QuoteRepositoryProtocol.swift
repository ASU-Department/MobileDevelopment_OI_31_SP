//
//  QuoteRepositoryProtocol.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

protocol QuoteRepositoryProtocol {
    func getQuote() async -> Quote
}
