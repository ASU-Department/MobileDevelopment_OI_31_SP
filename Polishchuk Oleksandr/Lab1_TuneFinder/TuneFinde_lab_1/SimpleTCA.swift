import Foundation
import Combine

protocol SimpleReducer {
    associatedtype State
    associatedtype Action

    func reduce(state: inout State, action: Action)
}

final class SimpleStore<R: SimpleReducer>: ObservableObject {

    @Published private(set) var state: R.State

    private let reducer: R

    init(initialState: R.State, reducer: R) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: R.Action) {
        reducer.reduce(state: &state, action: action)
    }
}
