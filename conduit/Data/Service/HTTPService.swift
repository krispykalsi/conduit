//
//  HTTPService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

protocol HTTPService {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

class HTTPClient: NSObject {
    init(authInteractor: AuthInteractor) {
        self.session = URLSession(configuration: .default)
        self.authInteractor = authInteractor
    }
    
    private let session: URLSession
    private let authInteractor: AuthInteractor
    
    static let shared: HTTPService = HTTPClient(authInteractor: AuthService.shared)
    
    private func authenticate(_ req: URLRequest) -> URLRequest {
        var reqWithAuthToken = req
        if let token = authInteractor.authToken {
            reqWithAuthToken.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        return reqWithAuthToken
    }
}

extension HTTPClient: HTTPService {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: authenticate(request), delegate: self)
    }
}

extension HTTPClient: URLSessionDelegate, URLSessionTaskDelegate {
    /// Handle redirects. Header gets removed from the new request.
    /// Ref: https://stackoverflow.com/a/46332804/13743674
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest) async -> URLRequest? {
        if request.url!.baseURL != response.url!.baseURL {
            return nil
        }
        return authenticate(request)
    }
}
