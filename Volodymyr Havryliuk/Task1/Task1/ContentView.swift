//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI

struct Book: Hashable, Identifiable {
    let id = UUID()
    let title: String
    var isRead: Bool = false
}

struct ContentView: View {
    @State var books: [Book] = [
        Book(title: "book 1"),
        Book(title: "book 2")
    ]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BookTracker")
                .bold()
                .font(.system(size: 36))
            List {
                ForEach($books) { $book in
                    BookRow(book: $book)
                }
            }
            Button("Add sample book") {
                books.append(Book(title: "Sample"))
            }
        }
        .padding()
    }
}

struct BookRow: View {
    @Binding var book: Book
    
    var body: some View {
        Toggle(book.title, isOn: $book.isRead)
        
    }
}

#Preview {
    ContentView()
}
