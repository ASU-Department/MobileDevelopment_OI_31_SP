//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 12/12/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CoinDetailViewModel: ObservableObject {
    let coin: CoinEntity
    @Published var chartData: [Double] = [100, 120, 110, 130, 150, 140, 160, 155]
    
    init(coin: CoinEntity) {
        self.coin = coin
    }
}
