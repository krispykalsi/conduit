//
//  HTTPService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

class HTTPService: NSObject, HTTPInteractor {
    init(authInteractor: AuthInteractor) {
        self.urlSession = URLSession(configuration: .default)
        self.authInteractor = authInteractor
    }
    
    private let urlSession: URLSession
    private let authInteractor: AuthInteractor
    
    static let shared: HTTPInteractor = HTTPService(authInteractor: AuthService.shared)
    
    private func authenticate(_ req: URLRequest) -> URLRequest {
        var reqWithAuthToken = req
        if let token = authInteractor.authToken {
            reqWithAuthToken.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        return reqWithAuthToken
    }
}

extension HTTPService {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await urlSession.data(for: authenticate(request), delegate: self)
    }
}

extension HTTPService: URLSessionDelegate, URLSessionTaskDelegate {
    /// Handle redirects. Header gets removed from the new request.
    /// Ref: https://stackoverflow.com/a/46332804/13743674
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest) async -> URLRequest? {
        if request.url!.baseURL != response.url!.baseURL {
            return nil
        }
        return authenticate(request)
    }
}
