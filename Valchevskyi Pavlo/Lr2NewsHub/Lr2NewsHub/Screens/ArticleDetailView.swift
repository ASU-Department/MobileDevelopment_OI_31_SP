//
//  ArticleDetailView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    @State private var showingShare = false
    @Bindable var article: ArticleModel
    
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
                    Text(article.title)
                        .font(.title2)
                        .bold()
                    Divider()
                    
                    VStack (alignment: .leading) {
                        Text("Category: \(article.category)")
                            .italic()
                        Text("Author: \(article.author)")
                            .italic()
                        Text("Published: \(article.published)")
                            .italic()
                    }

                    
                    Divider()
                    
                    
                    if let img = article.imageUrl {
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
                    
                    Text(article.text)
                    
                    if let urlString = article.articleUrl,
                       let url = URL(string: urlString) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Text("Open article source")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Divider()

                    Toggle("Add to favorite:", isOn: $article.isFavorite)
                    
                    Divider()
                    
                    VStack {
                        Text("Rate article: \(article.userPoint)")
                        SliderView(userPoint: $article.userPoint)
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
                ShareArticle(items: [article.title, article.text, article.category])
            }
        }
        .navigationTitle("View details")
    }
}

#Preview {
    do {
        let container = try ModelContainer(
            for: ArticleModel.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        
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

        return ArticleDetailView(article: mock)
            .modelContainer(container)

    } catch {
        return Text("Failed to load preview")
    }
}
