import XCTest
@testable import Pokedexter

@MainActor
class PokedexterViewModelTests: XCTestCase {
    
    func makeSUT() -> (PokemonListViewModel, MockPokemonRepository) {
        let mockRepository = MockPokemonRepository()
        let viewModel = PokemonListViewModel(repository: mockRepository)
        return (viewModel, mockRepository)
    }

    func testLoadData_Success() async {
        let (viewModel, mockRepository) = makeSUT()
        
        let testMon = Pokemon(id: 1, name: "Test", type: [], imageURL: nil, isFavorite: false, abilities: [], height: 10, weight: 10)
        mockRepository.mockPokemonList = [testMon]
        
        await viewModel.loadData()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.pokemonList.count, 1)
        XCTAssertFalse(mockRepository.lastRefreshValue)
    }
    
    func testLoadData_PullToRefresh() async {
        let (viewModel, mockRepository) = makeSUT()
        
        await viewModel.loadData(fromRefresh: true)
        
        XCTAssertTrue(mockRepository.lastRefreshValue)
    }

    func testLoadData_Failure_EmptyList_ShowsFullScreen() async {
        let (viewModel, mockRepository) = makeSUT()
        mockRepository.shouldReturnError = true
        viewModel.pokemonList = []
        
        await viewModel.loadData()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showRefreshErrorAlert)
    }
    
    func testLoadData_Failure_WithData_ShowsAlert() async {
        let (viewModel, mockRepository) = makeSUT()
        
        let testMon = Pokemon(id: 1, name: "Test", type: [], imageURL: nil, isFavorite: false, abilities: [], height: 10, weight: 10)
        viewModel.pokemonList = [testMon]
        mockRepository.shouldReturnError = true
        
        await viewModel.loadData(fromRefresh: true)
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showRefreshErrorAlert)
        XCTAssertEqual(viewModel.pokemonList.count, 1)
    }
    
    func testSearchFilter() {
        let (viewModel, _) = makeSUT()
        
        viewModel.pokemonList = [
            Pokemon(id: 1, name: "Bulbasaur", type: [], imageURL: nil, isFavorite: false, abilities: [], height: 10, weight: 10),
            Pokemon(id: 2, name: "Charmander", type: [], imageURL: nil, isFavorite: false, abilities: [], height: 10, weight: 10)
        ]
        
        viewModel.searchText = "Char"
        
        XCTAssertEqual(viewModel.filteredPokemon.count, 1)
        XCTAssertEqual(viewModel.filteredPokemon.first?.name, "Charmander")
    
        viewModel.searchText = ""
    }
    
    func testToggleFavorite_UpdatesList() {
        let (viewModel, _) = makeSUT()
        let p1 = Pokemon(id: 1, name: "Test", type: [], imageURL: nil, isFavorite: false, abilities: [], height: 10, weight: 10)
        viewModel.pokemonList = [p1]
        
        viewModel.toggleFavorite(for: 1)
        
        XCTAssertTrue(viewModel.pokemonList[0].isFavorite)
    }
}
