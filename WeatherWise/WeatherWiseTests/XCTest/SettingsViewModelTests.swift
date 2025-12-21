//
//  Untitled.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

@testable import WeatherWise
import XCTest
import Combine

final class SettingsViewModelTests: XCTestCase {

    func testInitialState() {
        let expectation = XCTestExpectation(description: "VM created")
        
        Task { @MainActor in
            let vm = SettingsViewModel()
            
            XCTAssertTrue(vm.use24HourFormat)
            XCTAssertEqual(vm.locationName, "Львів")
            XCTAssertFalse(vm.notificationsEnabled)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateLocation() {
        let expectation = XCTestExpectation(description: "Location updated")
        
        Task { @MainActor in
            let vm = SettingsViewModel()
            
            vm.locationName = "Київ"
            
            XCTAssertEqual(vm.locationName, "Київ")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testToggleNotifications() {
        let expectation = XCTestExpectation(description: "Notifications toggled")
        
        Task { @MainActor in
            let vm = SettingsViewModel()
            
            vm.notificationsEnabled.toggle()
            
            XCTAssertTrue(vm.notificationsEnabled)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
