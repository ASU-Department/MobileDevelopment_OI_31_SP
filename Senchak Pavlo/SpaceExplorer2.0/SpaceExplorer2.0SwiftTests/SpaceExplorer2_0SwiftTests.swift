//
//  SpaceExplorer2_0SwiftTests.swift
//  SpaceExplorer2.0SwiftTests
//
//  Created by Pab1m on 14.12.2025.
//

import Testing
@testable import SpaceExplorer2_0

@MainActor
struct ExploreViewModelTests {

    @Test
    func defaultBrightnessIsHalf() {
        let viewModel = ExploreViewModel()
        #expect(viewModel.brightness == 0.5)
    }

    @Test
    func brightnessCanBeChanged() {
        let viewModel = ExploreViewModel()

        viewModel.brightness = 0.8

        #expect(viewModel.brightness == 0.8)
    }

    @Test
    func brightnessAcceptsMinimumValue() {
        let viewModel = ExploreViewModel()

        viewModel.brightness = 0.0

        #expect(viewModel.brightness == 0.0)
    }

    @Test
    func brightnessAcceptsMaximumValue() {
        let viewModel = ExploreViewModel()

        viewModel.brightness = 1.0

        #expect(viewModel.brightness == 1.0)
    }
}
