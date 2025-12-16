//
//  CounterActor.swift
//  lab1Tests
//
//  Created by A-Z pack group on 16.12.2025.
//

import XCTest

actor CounterActor {
    private var value: Int = 0
    func inc() { value += 1 }
    func get() -> Int { value }
}

final class ActorBehaviorTests: XCTestCase {
    func test_actor_isThreadSafe_underConcurrency() async {
        let actor = CounterActor()

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1_000 {
                group.addTask { await actor.inc() }
            }
        }

        let v = await actor.get()
        XCTAssertEqual(v, 1_000)
    }
}
