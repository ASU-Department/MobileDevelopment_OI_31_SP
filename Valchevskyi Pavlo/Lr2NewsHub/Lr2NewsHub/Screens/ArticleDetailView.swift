//
//  ArticleDetailView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    @StateObject private var vm: ArticleDetailViewModel
    @State private var showingShare = false
    
    init(article: ArticleModel, repository: NewsRepositoryProtocol) {
        _vm = StateObject(wrappedValue: ArticleDetailViewModel(article: article, repository: repository))
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "newspaper")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("About article")
                    .font(.title2)
                    .italic()
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text(vm.article.title)
                        .font(.title2)
                        .bold()
                    Divider()
                    
                    VStack (alignment: .leading) {
                        Text("Category: \(vm.article.category)")
                            .italic()
                        Text("Author: \(vm.article.author)")
                            .italic()
                        Text("Published: \(vm.article.published)")
                            .italic()
                    }

                    
                    Divider()
                    
                    if let img = vm.article.imageUrl {
                        AsyncImage(url: URL(string: img)) {
                            phase in switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                case .failure:
                                    Image("not_load_pic").resizable()
                                @unknown default:
                                    Image("not_load_pic").resizable()
                            }
                        }
                        .frame(height: 200)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    
                    Divider()
                    Text(vm.article.text)
                    
                    if let urlString = vm.article.articleUrl, let url = URL(string: urlString) {
                        Button(action: { UIApplication.shared.open(url) }) {
                            Text("Open article source")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Divider()

                    Toggle("Add to favorite:", isOn: Binding(
                        get: {
                            vm.article.isFavorite
                        },
                        set: {
                            _ in vm.toggleFavorite()
                        }
                    ))
                    
                    Divider()
                    
                    VStack {
                        Text("Rate article: \(vm.article.userPoint)")
                        SliderView(userPoint: Binding(
                            get: {
                                vm.article.userPoint
                            },
                            set: {
                                vm.updateRating(to: $0)
                            }
                        ))
                    }
                }
                .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2)
            )
            
            Spacer()
            
            Button("Share Article") {
                showingShare = true
            }
            .sheet(isPresented: $showingShare) {
                ShareArticle(items: [vm.article.title, vm.article.text, vm.article.category])
            }
        }
        .navigationTitle("View details")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    do {
        let container = try ModelContainer(for: ArticleModel.self, configurations: config)
        
        let mock = ArticleModel(
            id: "temp_id_for_test",
            title: "Armed men abduct children and staff at a Catholic school in Nigeria",
            text: "Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...Gunmen attacked a Catholic boarding school in Nigeria...",
            category: "World",
            articleUrl: "urlArticle",
            imageUrl: "https://ichef.bbci.co.uk/news/1024/branded_news/447e/live/440a5730-c743-11f0-8c06-f5d460985095.jpg",
//            imageUrl: "if load fail",
            author: "Paul Vincent",
            published: "2025-11-21 15:28"
        )
        
        container.mainContext.insert(mock)
        
        let repository = NewsRepository(container: container)
        
        return NavigationStack {
            ArticleDetailView(article: mock, repository: repository)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
