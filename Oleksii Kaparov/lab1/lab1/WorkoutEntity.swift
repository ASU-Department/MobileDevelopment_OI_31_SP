//
//  WorkoutEntity.swift
//  lab1
//
//  Created by A-Z pack group on 11.12.2025.
//

import Foundation
import CoreData

extension WorkoutEntity {
    func toDomain() -> Workout {
        let exSet = exercises as? Set<ExerciseEntity> ?? []
        let items: [ExerciseItem] = exSet
            .map {
                ExerciseItem(
                    id: $0.id ?? UUID(),
                    name: $0.name ?? "",
                    sets: Int($0.sets),
                    reps: Int($0.reps)
                )
            }
            .sorted { $0.name < $1.name }

        return Workout(
            id: id ?? UUID(),
            name: name ?? "",
            exercises: items,
            date: date ?? Date(),
            intensity: intensity
        )
    }
}
