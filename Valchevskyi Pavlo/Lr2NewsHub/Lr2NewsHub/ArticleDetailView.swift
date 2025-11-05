//
//  ArticleDetailView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import UIKit

struct ArticleDetailView: View {
    @Binding var article: Article
    @State private var showingShare = false
    
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
            
            Form {
                Section(header: Text("Article Info").bold()) {
                    HStack {
                        Text("Title:")
                            .bold()
                        Text(article.title)
                    }
                    
                    HStack {
                        Text("Category:")
                            .bold()
                        Text(article.category)
                    }
                }
            
                Section(header: Text("Article Details").bold()) {
                    Text(article.text)
                }
                
                Section(header: Text("Save Offline Article").bold()) {
                    Toggle("Save offline", isOn: $article.isSaveOffline)
                }
                
                Section(header: Text("Rate Article").bold()) {
                    VStack {
                        Text("Point: \(article.userPoint)")
                        SliderView(userPoint: $article.userPoint)
                            .frame(height: 25)
                    }
                }
            }
            .border(Color.blue, width: 1)
            
            Spacer()
            
            Section {
                Button("Share Article") {
                    showingShare = true
                }
                .sheet(isPresented: $showingShare) {
                    ShareArticle(items: [article.title, article.text, article.category])
                }
            }
        }
        .navigationTitle("View details")
    }
}

struct ShareArticle: UIViewControllerRepresentable {
    let items: [String]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ArticleDetailView(article: .constant(
        Article(title: "Title",
                text: "Text",
                category: "Category",
                isSaveOffline: false)
    ))
}

struct SliderView: UIViewRepresentable {
    @Binding var userPoint: Int
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.value = Float(userPoint)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(userPoint)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $userPoint)
    }
    
    class Coordinator: NSObject {
        var value: Binding<Int>
        
        init(value: Binding<Int>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Int(sender.value)
        }
    }
}
