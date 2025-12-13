//
//  LaunchViewModel.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 12/12/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LaunchViewModel: ObservableObject {
    
    enum LaunchState {
        case launching
        case finished
    }
    
    @Published var launchState: LaunchState = .launching
    
    private let repository: CoinRepositoryProtocol
    
    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }
    
    func orchestrateLaunchSequence() async {
        await withTaskGroup(of: Void.self) { group in
            
            group.addTask {
                try? await Task.sleep(for: .seconds(2.5))
            }
            
            group.addTask {
                do {
                    let coins = try await self.repository.getCoins()
                    if coins.isEmpty {
                        try await self.repository.fetchData(force: true)
                    } else {
                        try? await self.repository.fetchData(force: false)
                    }
                } catch {
                    print("Failed to load initial coins: \(error)")
                }
            }
        }
        
        withAnimation {
            launchState = .finished
        }
    }
}
