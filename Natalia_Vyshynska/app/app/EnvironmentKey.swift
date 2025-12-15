import SwiftUI

private struct FavoriteRepositoryKey: EnvironmentKey {
    static let defaultValue: FavoriteRepositoryProtocol = {
        fatalError("FavoriteRepository not provided")
    }()
}

extension EnvironmentValues {
    var favoriteRepository: FavoriteRepositoryProtocol {
        get { self[FavoriteRepositoryKey.self] }
        set { self[FavoriteRepositoryKey.self] = newValue }
    }
}
// py py py
