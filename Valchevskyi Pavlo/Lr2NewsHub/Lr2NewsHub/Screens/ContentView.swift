//
//  ContentView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject var vm: NewsViewModel
    @StateObject var settings = AppSettings()

    init() {
        let container = try! ModelContainer(for: ArticleModel.self)
        _vm = StateObject(wrappedValue: NewsViewModel(context: container.mainContext))
    }
    
    var categories: [String] {
        let setCategories = Set(vm.articles.map { $0.category })
        return ["All"] + setCategories.sorted()
    }

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
                        .italic()
                    Picker("Category", selection: $settings.selectedCategory) {
                        ForEach(categories, id: \.self) {
                            category in Text(category)
                        }
                    }
                }
                
                HStack() {
                    Text("Show favorite:")
                        .italic()
                    Toggle("", isOn: $settings.filterFavorite)
                        .labelsHidden()
                }

                
                if vm.isLoading {
                    ProgressView("Loading remote news...")
                        .padding()
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
                
                List {
                    let filteredByCategory = vm.articles.filter { settings.selectedCategory == "All" || $0.category == settings.selectedCategory }
                    
                    let finalArticles = settings.filterFavorite ? filteredByCategory.filter { $0.isFavorite } : filteredByCategory

                    ForEach(finalArticles) { article in
                        NavigationLink(article.title) {
                            ArticleDetailView(article: article)
                        }
                    }
                    
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .refreshable {
                    await vm.fetchRemoteNews()
                }
                
                Spacer()
                
                VStack {
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
            .task {
                await vm.fetchRemoteNews()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ArticleModel.self, configurations: config)

    
    let context = container.mainContext
    
    return ContentView()
        .modelContainer(container)
}
