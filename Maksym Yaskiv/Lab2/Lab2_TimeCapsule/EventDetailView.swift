//
//  EventDetailView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI

struct EventDetailView: View {
    let event: HistoricalEvent
    
    @State private var isShowingSafari = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(event.text)
                .font(.title2)
                .padding()

            Button("Read More...") {
                isShowingSafari = true
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .navigationTitle("Details")
        .sheet(isPresented: $isShowingSafari) {
            SafariView(url: URL(string: event.urlString)!)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: HistoricalEvent(
            text: "1989 — Fall of Berlin Wall",
            urlString: "https://en.wikipedia.org/wiki/Berlin_Wall",
            isFavorite: true
        ))
    }
}