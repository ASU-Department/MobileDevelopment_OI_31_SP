//
//  Store.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import SwiftUI

@Observable
class BookStore {
    static let shared = BookStore()
    
    var books: [Book] = []
    
    func loadMock() {
        books = [
            Book(title: "The Swift Programming Language", isRead: true, notes: "Essential.", rating: 5.0),
            Book(title: "Clean Code", isRead: false, notes: "Reading chapter 3.", rating: 4.5),
            Book(title: "Design Patterns", isRead: true, notes: "Reference.", rating: 4.0)
        ]
    }
}
