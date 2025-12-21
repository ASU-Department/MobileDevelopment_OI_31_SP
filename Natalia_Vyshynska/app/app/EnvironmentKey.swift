import SwiftUI

private struct FavoriteRepositoryKey: EnvironmentKey {
    static let defaultValue: FavoriteRepositoryProtocol? = nil
}

extension EnvironmentValues {
    var favoriteRepository: FavoriteRepositoryProtocol? {
        get { self[FavoriteRepositoryKey.self] }
        set { self[FavoriteRepositoryKey.self] = newValue }
    }
}
