import SwiftUI

struct PokemonDetailView: View {
    @Binding var pokemon: Pokemon
    
    @State private var showSafari = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pokémon Image
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
                                .foregroundColor(.secondary)
                            Text("\(pokemon.height) dm")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Weight")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(pokemon.weight) hg")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Abilities")
                            .font(.headline)
                            .padding(.bottom, 2)
                        
                        ForEach(pokemon.abilities, id: \.self) { ability in
                            HStack {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(ability)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button(action: {
                        showSafari = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Read more on Wiki")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top)
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
        .sheet(isPresented: $showSafari) {
            if let url = URL(string: "https://pokemon.fandom.com/wiki/\(pokemon.name)") {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
            }
        }
    }
}

