//
//  CoreDataEntities.swift
//  lab1
//
//  Created by A-Z pack group on 11.12.2025.
//

import Foundation
import CoreData

@objc(WorkoutEntity)
public final class WorkoutEntity: NSManagedObject {}

extension WorkoutEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var intensity: Double
    @NSManaged public var exercises: NSSet?
}

@objc(ExerciseEntity)
public final class ExerciseEntity: NSManagedObject {}

extension ExerciseEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sets: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var workout: WorkoutEntity?
}

@objc(RemoteCacheEntity)
public final class RemoteCacheEntity: NSManagedObject {}

extension RemoteCacheEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RemoteCacheEntity> {
        NSFetchRequest<RemoteCacheEntity>(entityName: "RemoteCacheEntity")
    }

    @NSManaged public var payload: Data?
    @NSManaged public var updatedAt: Date?
}
