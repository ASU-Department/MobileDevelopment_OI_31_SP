//
//  ContentView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
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
            
            List {
                HStack {
                        Text("Article")
                            .bold()
                        Spacer()
                        Text("Save\noffline")
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                    ForEach($news) { $article in
                        if selectedCategory == "All" || article.category == selectedCategory {
                            ArticleRow(article: $article).padding(2)
                        }
                    }
            }

            Spacer()
               
            HStack {
                Text("(c) News Hub")
                    .italic()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
        }
    }
}

struct ArticleRow: View {
    @Binding var article: Article
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            Toggle(article.title, isOn: $article.isSaveOffline)
            
            if isExpanded {
                Text(article.text)
                    
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "View less" : "View more")
            }
        }
    }
}

#Preview {
    ContentView()
}
