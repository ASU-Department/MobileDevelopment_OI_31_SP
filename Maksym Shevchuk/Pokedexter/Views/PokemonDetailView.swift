import SwiftUI

struct PokemonDetailView: View {
    @Binding var pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: pokemon.imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                
                VStack(spacing: 10) {
                    Text(pokemon.name)
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        ForEach(pokemon.type, id: \.self) { type in
                            TypeBadge(type: type, isSelected: true)
                        }
                    }
                    
                    HStack {
                        VStack {
                            Text("Height")
                                .font(.caption)
                            Text("\(pokemon.height) dm")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Weight")
                                .font(.caption)
                            Text("\(pokemon.weight) hg")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Abilities:")
                            .font(.headline)
                        ForEach(pokemon.abilities, id: \.self) { ability in
                            Text("• \(ability)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    pokemon.isFavorite.toggle()
                }) {
                    Image(systemName: pokemon.isFavorite ? "star.fill" : "star")
                        .foregroundColor(pokemon.isFavorite ? .yellow : .gray)
                }
            }
        }
    }
}
