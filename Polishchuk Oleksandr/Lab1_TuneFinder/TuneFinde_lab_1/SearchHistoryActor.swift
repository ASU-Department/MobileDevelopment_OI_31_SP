import Foundation

actor SearchHistoryActor {
    private var queries: [String] = []

    func add(_ term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // видаляємо дублікати (по регістру незалежно)
        queries.removeAll { $0.caseInsensitiveCompare(trimmed) == .orderedSame }
        queries.insert(trimmed, at: 0)

        // зберігаємо тільки 10 останніх
        if queries.count > 10 {
            queries = Array(queries.prefix(10))
        }
    }

    func all() -> [String] {
        queries
    }

    func clear() {
        queries.removeAll()
    }
}
