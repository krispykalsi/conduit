//
//  JSONService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 30/05/22.
//

import Foundation


protocol IJSONService {
    func encode<T : Encodable>(_ data: T) throws -> Data
    func decode<T : Decodable>(_ data: Data) throws -> T
}

class JSONService: IJSONService {
    internal init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        self.jsonEncoder = encoder
        self.jsonDecoder = decoder
    }
    
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    static let shared: IJSONService = JSONService()
    
    func encode<T>(_ data: T) throws -> Data where T : Encodable {
        return try jsonEncoder.encode(data)
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
