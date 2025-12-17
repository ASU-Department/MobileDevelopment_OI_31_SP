//
//  JSONDecoder.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation

extension JSONDecoder {
    static let github: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}
