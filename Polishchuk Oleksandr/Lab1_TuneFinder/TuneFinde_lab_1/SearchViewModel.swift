import Foundation
import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = ITunesService()
    
    func search() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            results = try await service.searchSongs(term: query)
            if results.isEmpty {
                errorMessage = "No results. Try another query."
            }
        } catch {
            errorMessage = "Network error. Please try again."
        }
    }
}
