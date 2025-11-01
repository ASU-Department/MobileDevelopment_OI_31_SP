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
    var userPoint: Int = 0
}

struct ContentView: View {
    @State var selectedCategory: String = "All"
    @State private var showingSuggestArticle = false
  
    @State var news: [Article]
    let categories: [String]

    var body: some View {
        NavigationStack {
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
                            NavigationLink(destination: ArticleDetailView(article: $article)) {
                                ArticleRow(article: $article).padding(2)
                            }
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Button("Suggest article") {
                        showingSuggestArticle = true
                    }
                    HStack {
                        Text("(c) News Hub")
                            .italic()
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                    }
                    .padding(.top)
                }
            }
            .sheet(isPresented: $showingSuggestArticle) {
                CreateMySuggestArticle { newArticle in
                    news.append(newArticle)
                    showingSuggestArticle = false
                }
            }
        }
    }
}

struct ArticleRow: View {
    @Binding var article: Article
    
    var body: some View {
        VStack {
            Toggle(article.title, isOn: $article.isSaveOffline)
        }
    }
}

#Preview {
    ContentView(
        news: [
            Article(title: "Title 1", text: "Text 1", category: "Category 1"),
            Article(title: "Title 2", text: "Text 2", category: "Category 2")
        ],
        categories: ["All", "Category 1", "Category 2", "My suggest news"]
    )
}
