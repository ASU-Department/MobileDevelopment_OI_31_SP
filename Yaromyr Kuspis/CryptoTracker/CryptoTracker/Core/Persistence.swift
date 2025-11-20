//
//  Persistence.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 03.11.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CryptoTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveCoins(from cryptoModels: [Crypto]) {
        let context = container.viewContext
        
        // Perform database operations on the correct background queue to avoid UI freezes.
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
                let existingCoins = try context.fetch(fetchRequest)
                
                // Clear the existing cache to prevent duplicates before inserting new data.
                for coin in existingCoins {
                    context.delete(coin)
                }
                
                for coinModel in cryptoModels {
                    let coinEntity = CoinEntity(context: context)
                    coinEntity.id = coinModel.id
                    coinEntity.name = coinModel.name
                    coinEntity.symbol = coinModel.symbol
                    coinEntity.image = coinModel.image
                    coinEntity.currentPrice = coinModel.currentPrice
                    
                    // Preserve the favorite status for coins that were already in the portfolio.
                    let wasFavorite = existingCoins.first { $0.id == coinModel.id }?.isFavorite ?? false
                    coinEntity.isFavorite = wasFavorite
                    
                    coinEntity.priceChangePercentage24h = coinModel.priceChangePercentage24h ?? 0.0
                }
                
                // Save all changes (deletions and insertions) in a single transaction.
                try context.save()
                
            } catch {
                let nsError = error as NSError
                print("Unresolved error during saveCoins: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
