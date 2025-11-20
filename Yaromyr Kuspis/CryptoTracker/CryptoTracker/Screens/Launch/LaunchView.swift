//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 20.11.2025.
//

import SwiftUI
import SwiftData

// This view acts as a gatekeeper, coordinating the splash screen and initial data load.
struct LaunchView: View {
    @Environment(\.modelContext) private var modelContext
    
    enum LaunchState {
        case launching
        case finished
    }
    
    @State private var launchState: LaunchState = .launching
    
    private let coinService = CoinGeckoService()
    
    var body: some View {
        ZStack {
            if launchState == .launching {
                SplashScreenView()
                    .transition(.opacity.animation(.easeOut(duration: 0.5)))
            } else {
                CryptoListView()
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
            }
        }
        .task {
            await orchestrateLaunchSequence()
        }
    }
    
    private func orchestrateLaunchSequence() async {
        // We run the minimum splash duration and the data fetch in parallel.
        // The view will only transition after BOTH are complete.
        await withTaskGroup(of: Void.self) { group in
            
            // Task 1: Ensure the splash screen is visible for a minimum duration.
            group.addTask {
                try? await Task.sleep(for: .seconds(2.5))
            }
            
            // Task 2: Fetch initial data if the database is empty.
            group.addTask { @MainActor in
                let fetchDescriptor = FetchDescriptor<Coin>()
                let count = (try? modelContext.fetchCount(fetchDescriptor)) ?? 0
                
                if count == 0 {
                    do {
                        let cryptoModels = try await coinService.fetchCoins()
                        for coinModel in cryptoModels {
                            let newCoin = Coin(from: coinModel)
                            modelContext.insert(newCoin)
                        }
                        try? modelContext.save()
                    } catch {
                        print("Failed to load initial coins: \(error)")
                    }
                }
            }
        }
        
        // This line will only be reached after both tasks in the group are finished.
        withAnimation {
            launchState = .finished
        }
    }
}
