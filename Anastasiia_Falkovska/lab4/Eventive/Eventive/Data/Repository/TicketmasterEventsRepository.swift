import Foundation


@available(iOS 17, *)
final class TicketmasterEventsRepository: EventsRepository {

    private let store: EventsStoreActor

    init(store: EventsStoreActor) {
        self.store = store
    }

    func searchEvents(keyword: String) async throws -> [Event] {
        do {
            let events = try await fetchEvents(keyword: keyword)
            await store.save(events)
            return events
        } catch {
            let cached = await store.load()
            if cached.isEmpty {
                throw error
            }
            return cached
        }
    }
}
