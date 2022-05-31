//
//  HTTPInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 30/05/22.
//

import Foundation

protocol HTTPInteractor {
    func send(_ request: inout URLRequest) async throws -> (Data, URLResponse)
}
