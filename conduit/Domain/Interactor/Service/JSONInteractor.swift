//
//  JsonService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

protocol JSONInteractor {
    func encode<T : Encodable>(_ data: T) throws -> Data
    func decode<T : Decodable>(_ data: Data) throws -> T
}
