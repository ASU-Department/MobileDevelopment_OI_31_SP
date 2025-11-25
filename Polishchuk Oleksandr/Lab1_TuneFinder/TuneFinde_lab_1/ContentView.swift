import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SearchView()
                .navigationTitle("TuneFinder")
        }
    }
}

#Preview {
    ContentView()
}
