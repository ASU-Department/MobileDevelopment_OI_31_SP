import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "cloud.sun") {
                HomeView()
            }
            .badge(1)

            Tab("Explore", systemImage: "airplane") {
                ExploreView()
            }
        }
    }
}

#Preview {
    MainView()
}
