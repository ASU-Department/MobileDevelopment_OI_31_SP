import SwiftUI
import SwiftData

@available(iOS 17, *)
struct EventsListView: View {
    
    let keyword: String
    
    @Environment(\.modelContext) private var context
    @Query private var savedEvents: [Event]
    
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorText: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Пошук…")
                
            } else if let errorText {
                Text(errorText)
                    .foregroundColor(.red)
                
            } else {
                List(events) { event in
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text(event.city)
                        Text(event.date)
                            .font(.caption)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
        isLoading = true
        errorText = nil
        events = []
        
        do {
            let fetched = try await fetchEvents(keyword: keyword)
            
            events = fetched
            
            for event in fetched {
                context.insert(event)
            }
            
            UserDefaults.standard.set(Date(), forKey: "lastUpdate")
            
        } catch {
            if !savedEvents.isEmpty {
                events = savedEvents
            } else {
                errorText = "Не вдалося завантажити події"
            }
        }
        
        isLoading = false
    }
}
