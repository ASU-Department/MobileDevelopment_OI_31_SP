//
//  ContentView.swift
//  Lr1NewsHub
//
//  Created by Pavlo on 17.10.2025.
//

import SwiftUI

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let category: String
    var isSaveOffline: Bool = false
}

struct ContentView: View {
    @State var selectedCategory: String = "All"
    
    @State var news: [Article] = [
        Article(title: "Tittle article 1", text: "Text article 1", category: "Category 1"),
        Article(title: "Tittle article 2", text: "Text article 2", category: "Category 2")
    ]
    
    let categories = ["All", "Category 1", "Category 2"]

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("News Hub")
                    .font(.title)
                    .bold()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            .padding()
            
            HStack {
                Text("Choose category:")
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        category in Text(category)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
