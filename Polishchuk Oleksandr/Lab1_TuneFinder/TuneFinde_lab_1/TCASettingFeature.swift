import SwiftUI

// MARK: - TCA Feature: Settings

/// State для TCA-фічі
struct TCASettingsState: Equatable {
    var enableHaptics: Bool = true
    var enableSoundOnFavorite: Bool = false
    var favoritesLimit: Int = 20
}

/// Action-и, які може ініціювати вʼю
enum TCASettingsAction {
    case setHaptics(Bool)
    case setSoundOnFavorite(Bool)
    case setFavoritesLimit(Int)
    case resetToDefaults
}

/// Reducer, який змінює state залежно від action
struct TCASettingsReducer: SimpleReducer {

    func reduce(state: inout TCASettingsState, action: TCASettingsAction) {
        switch action {
        case .setHaptics(let value):
            state.enableHaptics = value

        case .setSoundOnFavorite(let value):
            state.enableSoundOnFavorite = value

        case .setFavoritesLimit(let limit):
            // примітивна валідація
            state.favoritesLimit = max(1, min(100, limit))

        case .resetToDefaults:
            state = TCASettingsState() // повертаємо дефолт
        }
    }
}

// MARK: - SwiftUI View над Store

struct TCASettingsView: View {
    @ObservedObject var store: SimpleStore<TCASettingsReducer>

    var body: some View {
        Form {
            Section("Feedback") {
                Toggle("Enable haptics", isOn: Binding(
                    get: { store.state.enableHaptics },
                    set: { store.send(.setHaptics($0)) }
                ))

                Toggle("Play sound when adding to favorites",
                       isOn: Binding(
                        get: { store.state.enableSoundOnFavorite },
                        set: { store.send(.setSoundOnFavorite($0)) }
                       ))
            }

            Section("Favorites") {
                Stepper(
                    "Favorites limit: \(store.state.favoritesLimit)",
                    value: Binding(
                        get: { store.state.favoritesLimit },
                        set: { store.send(.setFavoritesLimit($0)) }
                    ),
                    in: 1...100
                )
            }

            Section {
                Button("Reset to defaults") {
                    store.send(.resetToDefaults)
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("TCA Settings")
    }
}

// Для превʼю / тесту
#Preview {
    let store = SimpleStore(
        initialState: TCASettingsState(),
        reducer: TCASettingsReducer()
    )
    return NavigationStack {
        TCASettingsView(store: store)
    }
}
