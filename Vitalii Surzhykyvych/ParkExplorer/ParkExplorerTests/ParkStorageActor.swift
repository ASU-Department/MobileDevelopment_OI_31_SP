//
//  ParkStorageActor.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest
@testable import ParkExplorer
import SwiftData

final class ParkStorageActorTests: XCTestCase {

    func testActorSaveAndLoad() async {
        await MainActor.run {
            let context = PersistenceController.shared.container.mainContext
            let actor = ParkStorageActor(context: context)
            
            Task {
                let parks = [ParkAPIModel.mock(id: "actor")]
                
                await actor.save(parks)
                
                let loaded = await actor.load()
                
                let firstId = loaded.first?.id
                XCTAssertEqual(firstId, "actor")
            }
        }
    }
}
