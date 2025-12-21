import Foundation

@available(iOS 17, *)
protocol EventsRepository {
    func searchEvents(keyword: String) async throws -> [Event]
}
