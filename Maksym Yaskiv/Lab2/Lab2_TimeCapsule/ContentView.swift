//
//  ContentView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HistoricalEvent.year) private var events: [HistoricalEvent]
    @AppStorage("eventFontSize") private var eventFontSize: Double = 16.0
    
    @State private var selectedDate = Date()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false

    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .onChange(of: selectedDate) {
                            Task { await loadData() }
                        }
                    
                    if isLoading {
                        ProgressView("Loading history...")
                            .padding()
                    }
                    
                    List {
                        if events.isEmpty && !isLoading {
                            ContentUnavailableView("No events found", systemImage: "clock")
                        }
                        
                        ForEach(events) { event in
                            NavigationLink(value: event) {
                                HStack {
                                    Text(event.year).bold().foregroundStyle(.blue)
                                    Text(event.text)
                                        .font(.system(size: eventFontSize))
                                        .lineLimit(2)
                                    Spacer()
                                    if event.isFavorite {
                                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteEvents)
                    }
                    .refreshable {
                        await loadData()
                    }
                }
                .navigationTitle("🕰️ TimeCapsule")
                .navigationDestination(for: HistoricalEvent.self) { event in
                    EventDetailView(event: event)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: SettingsView(fontSize: $eventFontSize)) {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
            .tabItem { Label("Events", systemImage: "calendar") }

            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
        .tint(.yellow)
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }
    
    func loadData() async {
        isLoading = true
        let month = Calendar.current.component(.month, from: selectedDate)
        let day = Calendar.current.component(.day, from: selectedDate)
        
        do {
            let wikiEvents = try await NetworkManager.shared.fetchEvents(month: month, day: day)
            
            await MainActor.run {
                for dto in wikiEvents {
                    let urlLink = dto.pages?.first?.content_urls.desktop.page ?? ""
                    let newEvent = HistoricalEvent(
                        text: dto.text,
                        year: String(dto.year),
                        urlString: urlLink
                    )
                    modelContext.insert(newEvent)
                }
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = "Offline Mode: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: HistoricalEvent.self, configurations: config)
    
    let mockEvent1 = HistoricalEvent(
        text: "Preview Event: Swift was released",
        year: "2014",
        urlString: "https://apple.com"
    )
    let mockEvent2 = HistoricalEvent(
        text: "Another Event: Man lands on Mars",
        year: "2030",
        urlString: ""
    )
    mockEvent2.isFavorite = true
    
    container.mainContext.insert(mockEvent1)
    container.mainContext.insert(mockEvent2)
    
    return ContentView()
        .modelContainer(container)
}