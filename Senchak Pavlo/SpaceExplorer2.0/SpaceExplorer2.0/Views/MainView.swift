import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var context

    var body: some View {

        let repository = APODRepository(
            service: APODService(),
            context: context
        )

        TabView {
            HomeView(
                viewModel: HomeViewModel(repository: repository)
            )
            .tabItem {
                Label("Home", systemImage: "cloud.sun")
            }
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "airplane")
            }
        }
    }
}

#Preview {
    MainView()
}
