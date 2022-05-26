//
//  JsonService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

protocol JSONService {
    func encode<T : Encodable>(_ data: T) throws -> Data
    func decode<T : Decodable>(_ data: Data) throws -> T
}

class JSONParser: JSONService {
    internal init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = decoder
    }
    
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    static let shared: JSONService = JSONParser()
    
    func encode<T>(_ data: T) throws -> Data where T : Encodable {
        return try jsonEncoder.encode(data)
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
