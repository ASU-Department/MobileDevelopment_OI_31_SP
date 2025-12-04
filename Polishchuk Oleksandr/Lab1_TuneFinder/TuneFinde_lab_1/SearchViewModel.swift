import Foundation
import SwiftData
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var songs: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isOfflineMode: Bool = false

    private let service: ITunesService

    init(service: ITunesService = ITunesService()) {
        self.service = service
    }

    func loadCachedSongs(from context: ModelContext) {
        let descriptor = FetchDescriptor<SongEntity>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )

        if let cached = try? context.fetch(descriptor) {
            self.songs = cached.map { $0.toSong() }
            self.isOfflineMode = !cached.isEmpty
        }
    }

    func search(using context: ModelContext) async {
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isLoading = true
        errorMessage = nil
        isOfflineMode = false

        do {
            let remoteSongs = try await service.searchSongs(term: searchTerm)
            self.songs = remoteSongs

            // Очистити старий кеш
            let descriptor = FetchDescriptor<SongEntity>()
            if let old = try? context.fetch(descriptor) {
                for entity in old {
                    context.delete(entity)
                }
            }

            // Зберегти новий кеш результатів
            for song in remoteSongs {
                _ = SongEntity(from: song)
            }

            try? context.save()

            // Зберігаємо час останнього оновлення в UserDefaults
            UserDefaults.standard.set(
                Date().timeIntervalSince1970,
                forKey: "lastUpdateTimestamp"
            )
        } catch {
            // Якщо мережа впала — показуємо кеш
            self.errorMessage = (error as? ITunesError)?.localizedDescription ?? error.localizedDescription
            self.loadCachedSongs(from: context)
        }

        isLoading = false
    }

    var lastUpdateDate: Date? {
        let ts = UserDefaults.standard.double(forKey: "lastUpdateTimestamp")
        guard ts > 0 else { return nil }
        return Date(timeIntervalSince1970: ts)
    }
}
