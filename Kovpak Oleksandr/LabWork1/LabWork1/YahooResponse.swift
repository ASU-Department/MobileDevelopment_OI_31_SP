import Foundation

struct YahooResponse: Codable {
    let chart: ChartData
}

struct ChartData: Codable {
    let result: [StockResult]
}

struct StockResult: Codable {
    let meta: StockMeta
    let timestamp: [TimeInterval]?
    let indicators: Indicators
}

struct StockMeta: Codable {
    let symbol: String
    let regularMarketPrice: Double
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable {
    let close: [Double?]
}
