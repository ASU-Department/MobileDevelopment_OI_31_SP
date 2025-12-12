//
//  WorkoutCoreDataActor.swift
//  lab1
//
//  Created by A-Z pack group on 11.12.2025.
//

import Foundation
import CoreData

actor WorkoutCoreDataActor {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    private func newContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }

    // MARK: - Workouts

    func loadWorkouts() async throws -> [Workout] {
        let ctx = newContext()
        return try await ctx.perform {
            let req: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let entities = try ctx.fetch(req)
            return entities.map { $0.toDomain() }
        }
    }

    func saveWorkouts(_ workouts: [Workout]) async throws {
        let ctx = newContext()
        try await ctx.perform {
            let fetch: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            let existing = try ctx.fetch(fetch)
            existing.forEach { ctx.delete($0) }

            for w in workouts {
                let we = WorkoutEntity(context: ctx)
                we.id = w.id
                we.name = w.name
                we.date = w.date
                we.intensity = w.intensity

                for ex in w.exercises {
                    let ee = ExerciseEntity(context: ctx)
                    ee.id = ex.id
                    ee.name = ex.name
                    ee.sets = Int16(ex.sets)
                    ee.reps = Int16(ex.reps)
                    ee.workout = we
                }
            }

            if ctx.hasChanges {
                try ctx.save()
            }
        }
    }

    func deleteWorkout(id: UUID) async throws {
        let ctx = newContext()
        try await ctx.perform {
            let req: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let items = try ctx.fetch(req)
            items.forEach { ctx.delete($0) }
            if ctx.hasChanges { try ctx.save() }
        }
    }

    // MARK: - Cached remote exercises (stored as JSON blob in Core Data)

    func loadCachedRemoteExercises() async throws -> [ExerciseAPIModel] {
        let ctx = newContext()
        return try await ctx.perform {
            let req: NSFetchRequest<RemoteCacheEntity> = RemoteCacheEntity.fetchRequest()
            req.fetchLimit = 1
            let cache = try ctx.fetch(req).first
            guard let data = cache?.payload else { return [] }
            return try JSONDecoder().decode([ExerciseAPIModel].self, from: data)
        }
    }

    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) async throws {
        let ctx = newContext()
        try await ctx.perform {
            let req: NSFetchRequest<RemoteCacheEntity> = RemoteCacheEntity.fetchRequest()
            req.fetchLimit = 1

            let existing = try ctx.fetch(req).first ?? RemoteCacheEntity(context: ctx)
            existing.payload = try JSONEncoder().encode(exercises)
            existing.updatedAt = Date()

            if ctx.hasChanges {
                try ctx.save()
            }
        }
    }
}
