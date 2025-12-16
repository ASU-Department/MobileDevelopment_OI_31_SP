//
//  HomeViewModel.swift
//  SpaceExplorer2.0
//
//  Created by Pab1m on 13.12.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var apod: APODResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var counter = 0
    @Published var showToast = false

    private let repository: APODRepositoryProtocol

    init(repository: APODRepositoryProtocol) {
        self.repository = repository
    }

    func loadAPOD() async {
        isLoading = true
        errorMessage = nil

        do {
            apod = try await repository.loadAPOD()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func sendRating() {
        showToast = true
        counter = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}
