import SwiftUI


struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Pokémon...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
