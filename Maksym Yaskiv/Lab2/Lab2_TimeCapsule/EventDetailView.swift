//
//  EventDetailView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Bindable var event: HistoricalEvent
    @AppStorage("eventFontSize") private var fontSize: Double = 16.0
    @State private var isShowingSafari = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text(event.year)
                    .font(.largeTitle)
                    .bold()
                
                Text(event.text)
                    .font(.system(size: fontSize))
                
                VStack(spacing: 15) {
                    if let url = URL(string: event.urlString), !event.urlString.isEmpty {
                        Button("Read Full Article") {
                            isShowingSafari = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    Button(action: {
                        event.isFavorite.toggle()
                    }) {
                        Label(
                            event.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                            systemImage: event.isFavorite ? "star.fill" : "star"
                        )
                    }
                    .buttonStyle(.bordered)
                    .tint(event.isFavorite ? .orange : .blue)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingSafari) {
            if let url = URL(string: event.urlString) {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: HistoricalEvent.self, configurations: config)
        let event = HistoricalEvent(text: "Test Event", year: "2024", urlString: "https://google.com")
        return NavigationStack {
            EventDetailView(event: event)
        }
        .modelContainer(container)
    } catch { return Text("Error") }
}