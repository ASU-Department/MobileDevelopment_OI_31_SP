//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 20.11.2025.
//

import SwiftUI

struct LaunchView: View {
    
    @StateObject private var viewModel: LaunchViewModel
    
    private let repository: CoinRepositoryProtocol
    
    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: LaunchViewModel(repository: repository))
    }
    
    var body: some View {
        ZStack {
            if viewModel.launchState == .launching {
                SplashScreenView()
                    .transition(.opacity.animation(.easeOut(duration: 0.5)))
            } else {
                CryptoListView(repository: repository)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
            }
        }
        .task {
            await viewModel.orchestrateLaunchSequence()
        }
    }
}
