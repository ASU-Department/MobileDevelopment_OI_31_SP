//
//  habitBuddyApp.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//

import SwiftData
import SwiftUI

@main
struct habitBuddyApp: App {

    let container: ModelContainer

    init() {
        container = try! ModelContainer(for: Habit.self)
    }

    var body: some Scene {
        WindowGroup {

            let context = container.mainContext

            let habitStorage = HabitStorageActor(modelContext: context)
            let habitRepository = HabitRepository(storageActor: habitStorage)

            let quoteAPI = QuoteAPIService()
            let quoteCache = QuoteCacheActor()
            let quoteRepository = QuoteRepository(
                api: quoteAPI,
                cache: quoteCache
            )

            ContentView(
                habitViewModel: HabitListViewModel(repository: habitRepository),
                quoteViewModel: QuoteViewModel(repository: quoteRepository),
                addHabitViewModel: AddHabitViewModel(repository: habitRepository)
            )
        }
    }
}
