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
    
    // зручні computed-властивості для UI
    var primaryBodyPart: String {
        bodyParts.first ?? "unknown"
    }
    
    var primaryEquipment: String {
        equipments.first ?? "body weight"
    }
}
