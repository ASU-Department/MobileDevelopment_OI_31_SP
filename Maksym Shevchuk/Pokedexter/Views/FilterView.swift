import SwiftUI

struct FilterView: View {
    @Binding var showFavoritesOnly: Bool
    @Binding var selectedType: String
    
    let pokemonTypes = ["All", "Fire", "Water", "Grass", "Electric", "Psychic", "Poison"]
    
    var body: some View {
        VStack {
            Toggle("Show Favorites Only", isOn: $showFavoritesOnly)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(pokemonTypes, id: \.self) { type in
                        TypeBadge(type: type, isSelected: selectedType == type)
                            .onTapGesture {
                                selectedType = type
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
