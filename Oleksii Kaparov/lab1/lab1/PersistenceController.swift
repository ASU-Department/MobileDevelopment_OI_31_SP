//
//  PersistenceController.swift
//  lab1
//
//  Created by A-Z pack group on 11.12.2025.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WorkoutModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store load error: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
