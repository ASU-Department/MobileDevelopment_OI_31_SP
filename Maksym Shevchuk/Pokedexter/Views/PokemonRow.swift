//
//  PokemonRow.swift
//  Pokedexter
//
//  Created by kara on 12/11/25.
//

import SwiftUI



struct PokemonRow: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            AsyncImage(url: pokemon.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .font(.headline)
                HStack {
                    ForEach(pokemon.type, id: \.self) { type in
                        Text(type)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: pokemon.isFavorite ? "star.fill" : "star")
                .foregroundColor(pokemon.isFavorite ? .yellow : .gray)
        }
        .padding(.vertical, 4)
    }
}
