//
//  HTTPService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

class HTTPService: NSObject, HTTPInteractor {
    init(localAuthInteractor: LocalAuthInteractor) {
        self.urlSession = URLSession(configuration: .default)
        self.localAuthInteractor = localAuthInteractor
    }
    
    private let urlSession: URLSession
    private let localAuthInteractor: LocalAuthInteractor
    
    static let shared: HTTPInteractor = HTTPService(localAuthInteractor: LocalAuthService.shared)
    
    private func authenticate(_ req: inout URLRequest) {
        if let token = localAuthInteractor.authToken {
            req.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    private func addJSONHeaders(to req: inout URLRequest) {
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

extension HTTPService {
    func send(_ request: inout URLRequest) async throws -> (Data, URLResponse) {
        if request.httpBody != nil {
            addJSONHeaders(to: &request)
        }
        authenticate(&request)
        return try await urlSession.data(for: request, delegate: self)
    }
}

extension HTTPService: URLSessionDelegate, URLSessionTaskDelegate {
    /// Handle redirects. Header gets removed from the new request.
    /// Ref: https://stackoverflow.com/a/46332804/13743674
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest) async -> URLRequest? {
        if request.url!.baseURL != response.url!.baseURL {
            return nil
        }
        var req = request
        authenticate(&req)
        return req
    }
}
