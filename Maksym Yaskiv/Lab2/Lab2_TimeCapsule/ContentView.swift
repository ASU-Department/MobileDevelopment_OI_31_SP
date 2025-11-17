//
//  ContentView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI

struct HistoricalEvent: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let urlString: String
    var isFavorite: Bool = false
}

struct ContentView: View {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var events: [HistoricalEvent] = []
    @State private var selectedDate = Date()
    @State private var eventFontSize: CGFloat = 16.0

    init(previewEvents: [HistoricalEvent]? = nil) {
        if let previewEvents = previewEvents {
            _events = State(initialValue: previewEvents)
        }
    }

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    Section(header: Text("Select Date")) {
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .background(Color(.systemBackground)).cornerRadius(10)
                    }

                    Section(header: Text("Font Settings")) {
                        VStack {
                            Text("Size: \(Int(eventFontSize))")
                            FontSizeSlider(value: $eventFontSize, range: 12...24)
                        }
                        .padding(.vertical, 5)
                    }

                    Section(header: Text("Events This Day")) {
                        ForEach($events) { $event in
                            NavigationLink(value: event) {
                                HStack {
                                    Text(event.text)
                                        .font(.system(size: eventFontSize))
                                    Spacer()
                                    Image(systemName: event.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            event.isFavorite.toggle()
                                        }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("🕰️ TimeCapsule")
                .navigationDestination(for: HistoricalEvent.self) { event in
                    EventDetailView(event: event)
                }
            }
            .tabItem {
                Label("Events", systemImage: "calendar")
            }

            FavoritesView(events: $events)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
        .tint(.yellow)
        .onAppear {
            if events.isEmpty {
                events = appDelegate.initialEvents
            }
        }
    }
}

#Preview {
    ContentView(previewEvents: [
        HistoricalEvent(
            text: "1776 — Declaration of Independence",
            urlString: "https://en.wikipedia.org/wiki/United_States_Declaration_of_Independence",
            isFavorite: true
        ),
        HistoricalEvent(
            text: "1990 — World Wide Web is first proposed by Tim Berners-Lee",
            urlString: "https://en.wikipedia.org/wiki/World_Wide_Web",
            isFavorite: false
        ),
        HistoricalEvent(
            text: "1989 — Fall of Berlin Wall",
            urlString: "https://en.wikipedia.org/wiki/Berlin_Wall",
            isFavorite: false
        )
    ])
}