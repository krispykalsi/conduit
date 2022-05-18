//
//  UrlSessionExtensions.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URLRequest {
    init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
