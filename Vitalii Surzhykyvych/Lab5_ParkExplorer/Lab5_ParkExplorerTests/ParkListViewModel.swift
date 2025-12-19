//
//  ParkListViewModel.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest
@testable import Lab5_ParkExplorer
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

    func testLoadParksFailureUsesCache() async {
        let mock = ParkRepositoryMock()
        mock.shouldThrowError = true
        mock.parksToReturn = [.mock(id: "offline")]

        let vm = await ParkListViewModel(repository: mock)
        await vm.loadParks()

        let parks = await vm.parks
        let firstId = await parks.first?.id
        XCTAssertEqual(firstId, "offline")
    }
}
