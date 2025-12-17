import Foundation
import SwiftData

class StockRepository {
    private let actor: StockDataActor
    private let context: ModelContext
    
    init(container: ModelContainer) {
        self.actor = StockDataActor(container: container)
        self.context = ModelContext(container)
    }
    
    func fetchStockData(symbol: String) async throws -> (price: Double, history: [Double]) {
        guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?range=3mo&interval=1d") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(YahooResponse.self, from: data)
        
        if let result = decodedResponse.chart.result.first {
            let currentPrice = result.meta.regularMarketPrice
            let history = result.indicators.quote.first?.close.compactMap { $0 } ?? []
            
            await actor.saveStock(symbol: symbol, price: currentPrice)
            
            return (currentPrice, history)
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
    
    func fetchLocalStocks() -> [StockItem] {
        let descriptor = FetchDescriptor<StockItem>(sortBy: [SortDescriptor(\.symbol, order: .forward)])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func deleteStock(_ item: StockItem) {
        context.delete(item)
        try? context.save()
    }
}
