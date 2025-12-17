import Foundation
import SwiftData

actor StockDataActor {
    private var modelContainer: ModelContainer
    
    init(container: ModelContainer) {
        self.modelContainer = container
    }
    
    func saveStock(symbol: String, price: Double) {
        let context = ModelContext(modelContainer)
        
        let predicate = #Predicate<StockItem> { $0.symbol == symbol }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        if let existingStock = try? context.fetch(descriptor).first {
            existingStock.price = price
            existingStock.timestamp = Date()
        } else {
            let newItem = StockItem(symbol: symbol, price: price)
            context.insert(newItem)
        }
        
        try? context.save()
    }
}
