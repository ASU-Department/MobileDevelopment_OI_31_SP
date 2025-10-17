//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State var books: [String] = ["Book 1", "Book 2"]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BookTracker")
                .bold()
                .font(.system(size: 36))
            List {
                ForEach(books, id: \.self) { book in
                    Text(book)
                }
            }
            Button("Add sample book") {
                books.append("Sample book")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
