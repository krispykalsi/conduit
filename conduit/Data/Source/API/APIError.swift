//
//  APIError.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 29/05/22.
//

enum APIError: Error {
    case non200Response(code: Int, msg: String)
    case fromBackend(errors: [String])
    case unknown(msg: String)
}
