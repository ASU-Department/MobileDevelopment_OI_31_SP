//
//  ParkListViewModel.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest
@testable import ParkExplorer
import Foundation

final class ParkListViewModelTests: XCTestCase {

    func testLoadParksSuccess() async {
        let mock = ParkRepositoryMock()
        mock.parksToReturn = [.mock(id: "1")]

        let vm = await ParkListViewModel(repository: mock)

        await vm.loadParks()

        let parks = await vm.parks
        let isLoading = await vm.isLoading
        let errorMessage = await vm.errorMessage

        XCTAssertFalse(isLoading)
        XCTAssertEqual(parks.count, 1)
        XCTAssertNil(errorMessage)
    }
}
