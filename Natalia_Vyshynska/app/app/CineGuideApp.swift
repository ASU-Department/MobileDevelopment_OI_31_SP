import SwiftUI
import SwiftData

@main
struct CineGuideApp: App {
    @State private var dependencies: AppDependencyContainer?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some Scene {
        WindowGroup {
            if let deps = dependencies {
                ContentView()
                    .environment(\.favoriteRepository, deps.favoriteRepository)
                    .modelContainer(deps.modelContainer)
            } else if let error = errorMessage {
                VStack {
                    Text("Помилка запуску")
                        .font(.title)
                    Text(error)
                    Button("Спробувати ще") {
                        loadDependencies()
                    }
                }
            } else {
                ProgressView("Запуск додатка...")
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .onAppear(perform: loadDependencies)
            }
        }
    }
    
    private func loadDependencies() {
        Task { @MainActor in
            do {
                let container = try AppDependencyContainer()
                self.dependencies = container
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
