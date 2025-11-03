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
        
        // A simple caching strategy: delete all old data before saving the new batch.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoinEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete old coins: \(error), \(error.userInfo)")
        }
        
        cryptoModels.forEach { coinModel in
            let coinEntity = CoinEntity(context: context)
            coinEntity.id = coinModel.id
            coinEntity.name = coinModel.name
            coinEntity.symbol = coinModel.symbol
            coinEntity.image = coinModel.image
            coinEntity.currentPrice = coinModel.currentPrice
            coinEntity.priceChangePercentage24h = coinModel.priceChangePercentage24h ?? 0.0
        }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error saving coins: \(nsError), \(nsError.userInfo)")
        }
    }
}
