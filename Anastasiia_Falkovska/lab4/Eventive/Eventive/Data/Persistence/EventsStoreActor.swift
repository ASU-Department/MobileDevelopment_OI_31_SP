import SwiftData

@available(iOS 17, *)
actor EventsStoreActor {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ events: [Event]) {
        for event in events {
            context.insert(event)
        }
    }

    func load() -> [Event] {
        let descriptor = FetchDescriptor<Event>()
        return (try? context.fetch(descriptor)) ?? []
    }
}
