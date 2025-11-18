//
//  ExerciseAPIModel.swift
//  lab1
//
//  Created by A-Z pack group on 16.11.2025.
//
import Foundation

struct ExerciseAPIModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let imageUrl: String?
    let bodyParts: [String]
    let equipments: [String]
    let exerciseType: String?
    let targetMuscles: [String]
    let secondaryMuscles: [String]
    let keywords: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "exerciseId"
        case name
        case imageUrl
        case bodyParts
        case equipments
        case exerciseType
        case targetMuscles
        case secondaryMuscles
        case keywords
    }
    
    // ⚙️ Безпечне декодування: якщо ключа немає → []
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        imageUrl = try c.decodeIfPresent(String.self, forKey: .imageUrl)
        
        bodyParts = try c.decodeIfPresent([String].self, forKey: .bodyParts) ?? []
        equipments = try c.decodeIfPresent([String].self, forKey: .equipments) ?? []
        exerciseType = try c.decodeIfPresent(String.self, forKey: .exerciseType)
        targetMuscles = try c.decodeIfPresent([String].self, forKey: .targetMuscles) ?? []
        secondaryMuscles = try c.decodeIfPresent([String].self, forKey: .secondaryMuscles) ?? []
        keywords = try c.decodeIfPresent([String].self, forKey: .keywords) ?? []
    }
    
    // Зручно створювати вручну при потребі
    init(
        id: String,
        name: String,
        imageUrl: String? = nil,
        bodyParts: [String] = [],
        equipments: [String] = [],
        exerciseType: String? = nil,
        targetMuscles: [String] = [],
        secondaryMuscles: [String] = [],
        keywords: [String] = []
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.bodyParts = bodyParts
        self.equipments = equipments
        self.exerciseType = exerciseType
        self.targetMuscles = targetMuscles
        self.secondaryMuscles = secondaryMuscles
        self.keywords = keywords
    }
}
struct ExerciseSearchResponse: Codable {
    let data: [ExerciseAPIModel]
}

// допоміжні computed-властивості
extension ExerciseAPIModel {
    var primaryBodyPart: String {
        bodyParts.first ?? "N/A"
    }
    
    var primaryEquipment: String {
        equipments.first ?? "N/A"
    }
}
