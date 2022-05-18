//
//  EncodableUtils.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

import Foundation

extension Encodable {
    func data(using encoder: JSONEncoder = .init()) throws -> Data { try encoder.encode(self) }
    func dictionary(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: try data(using: encoder), options: options) as? [String: Any] ?? [:]
    }
}
