//
//  YahooResponse.swift
//  LabWork1
//
//  Created by Анна Лихоконь on 17.12.2025.
//

import Foundation
import Foundation

// Структура відповіді від Yahoo (щоб Codable міг це прочитати)
struct YahooResponse: Codable {
    let chart: ChartData
}

struct ChartData: Codable {
    let result: [StockResult]
}

struct StockResult: Codable {
    let meta: StockMeta
}

struct StockMeta: Codable {
    let symbol: String
    let regularMarketPrice: Double
}
