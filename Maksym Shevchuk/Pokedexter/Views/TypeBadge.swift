
import SwiftUI

struct TypeBadge: View {
    let type: String
    let isSelected: Bool
    
    var typeColor: Color {
        switch type {
        case "Fire": return .red
        case "Water": return .blue
        case "Grass": return .green
        case "Electric": return .yellow
        case "Psychic": return .purple
        case "Poison": return .indigo
        default: return .gray
        }
    }
    
    var body: some View {
        Text(type)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? typeColor : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(15)
    }
}
