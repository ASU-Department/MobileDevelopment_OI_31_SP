//
//  AppCoordinator.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import Combine
import SwiftData
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let repository: CityRepositoryProtocol
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        let persistenceActor = CityPersistenceActor(modelContext: modelContext)
        let networkService = NetworkService()
        self.repository = CityRepository(networkService: networkService, persistenceActor: persistenceActor)
    }
    
    func makeRootView() -> some View {
        makeCityListView()
    }
    
    func makeCityListView() -> CityListView {
        let viewModel = CityListViewModel(repository: repository)
        viewModel.coordinator = self
        return CityListView(viewModel: viewModel)
    }
    
    func makeCityDetailsView(city: City) -> CityDetailsView {
        let viewModel = CityDetailsViewModel(city: city, repository: repository)
        return CityDetailsView(viewModel: viewModel)
    }
    
    func showCityDetail(city: City) {
        path.append(city)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
