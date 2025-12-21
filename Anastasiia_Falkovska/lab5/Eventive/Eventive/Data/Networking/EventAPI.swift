import Foundation

struct APIResponse: Codable {
    let events: [APIEvent]
}

struct APIEvent: Codable {
    let id: String
    let name: String
    let city: String
    let date: String
}

@available(iOS 17, *)
func fetchEvents(keyword: String) async throws -> [Event] {

    let apiKey = "UrgUg8xrgpXwtcLaBdg8tR3AOd8q1S9C"

    let urlString =
    "https://app.ticketmaster.com/discovery/v2/events.json?keyword=\(keyword)&size=10&apikey=\(apiKey)"

    let url = URL(string: urlString)!
    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode(TicketmasterResponse.self, from: data)

    return decoded._embedded.events.map {
        Event(
            id: $0.id,
            name: $0.name,
            city: $0._embedded.venues.first?.city.name ?? "Unknown",
            date: $0.dates.start.localDate
        )
    }
}

struct TicketmasterResponse: Codable {
    let _embedded: EmbeddedEvents
}

struct EmbeddedEvents: Codable {
    let events: [TMEvent]
}

struct TMEvent: Codable {
    let id: String
    let name: String
    let dates: EventDates
    let _embedded: EmbeddedVenues
}

struct EventDates: Codable {
    let start: EventStart
}

struct EventStart: Codable {
    let localDate: String
}

struct EmbeddedVenues: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let city: City
}

struct City: Codable {
    let name: String
}
