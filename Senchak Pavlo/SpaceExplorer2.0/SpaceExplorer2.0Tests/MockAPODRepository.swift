import Foundation
@testable import SpaceExplorer2_0

final class MockAPODRepository: APODRepositoryProtocol {

    enum Result {
        case success(APODResponse)
        case failure(Error)
        case delayed(APODResponse, UInt64)
    }

    var result: Result?

    func loadAPOD() async throws -> APODResponse {
        guard let result else {
            fatalError("Mock result not set")
        }

        switch result {
        case .success(let apod):
            return apod

        case .failure(let error):
            throw error

        case .delayed(let apod, let delay):
            try await Task.sleep(nanoseconds: delay)
            return apod
        }
    }
}
