import Foundation
import SwiftUI

@available(iOS 17, *)
@MainActor
final class EventsViewModel: ObservableObject {

    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: EventsRepository

    init(repository: EventsRepository) {
        self.repository = repository
    }

    func search(keyword: String) {
        guard !keyword.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await repository.searchEvents(keyword: keyword)
                self.events = result
            } catch {
                self.errorMessage = "Не вдалося завантажити події"
            }

            self.isLoading = false
        }
    }
}

