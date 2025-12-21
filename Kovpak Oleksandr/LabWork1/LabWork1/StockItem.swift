//
//  StockItem.swift
//  LabWork1
//
//  Created by Анна Лихоконь on 17.12.2025.
//

import Foundation
import Foundation
import SwiftData

// Це наша модель для бази даних (SwiftData)
@Model
class StockItem {
    var symbol: String
    var price: Double
    var timestamp: Date
    
    init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
        self.timestamp = Date()
    }
}
