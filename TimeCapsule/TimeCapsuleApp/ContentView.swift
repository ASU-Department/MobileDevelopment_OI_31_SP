//
//  ContentView.swift
//  TimeCapsuleApp
//
//  Created by Mornacael on 19.10.2025.
//
import SwiftUI

struct HistoricalEvent: Identifiable {
    let id = UUID()
    let text: String
    var isFavorite: Bool = false
}

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var showEvents = false
    
    @State private var events: [HistoricalEvent] = [
        HistoricalEvent(text: "1492 — Columbus discovers America"),
        HistoricalEvent(text: "1969 — Apollo 11 lands on the Moon"),
        HistoricalEvent(text: "2007 — First iPhone released")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🕰️ TimeCapsule")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            
            Button(showEvents ? "Hide Events" : "Show Events") {
                showEvents.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            if showEvents {
                VStack(spacing: 10) {
                    ForEach($events) { $event in
                        EventRow(event: event.text, isFavorite: $event.isFavorite)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct EventRow: View {
    let event: String
    @Binding var isFavorite: Bool
    
    var body: some View {
        HStack {
            Text(event)
            Spacer()
            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}