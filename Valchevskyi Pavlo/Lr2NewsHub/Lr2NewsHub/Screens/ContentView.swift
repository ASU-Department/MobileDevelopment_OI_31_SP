//
//  ContentView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var vm: ContentViewModel
    @StateObject var settings = AppSettings()
    
    let repository: NewsRepositoryProtocol

    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
        _vm = StateObject(wrappedValue: ContentViewModel(repository: repository))
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
                    Text("Choose category:").italic()
                    Picker("Category", selection: $settings.selectedCategory) {
                        ForEach(vm.availableCategories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .onChange(of: settings.selectedCategory) { _, newValue in
                        vm.updateFilters(category: newValue, favoriteOnly: settings.filterFavorite)
                    }
                }
                
                HStack {
                    Text("Show favorite:")
                        .italic()
                    Toggle("", isOn: $settings.filterFavorite)
                        .labelsHidden()
                        .onChange(of: settings.filterFavorite) { _, newValue in
                            vm.updateFilters(category: settings.selectedCategory, favoriteOnly: newValue)
                        }
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
                vm.updateFilters(category: settings.selectedCategory, favoriteOnly: settings.filterFavorite)
                await vm.fetchRemoteNews()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ArticleModel.self, configurations: config)
    let repository = NewsRepository(container: container)
    
    return ContentView(repository: repository)
}
