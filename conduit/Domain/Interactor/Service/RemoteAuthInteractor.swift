//
//  RemoteAuthInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 31/05/22.
//

protocol RemoteAuthInteractor {
    func login(withEmail user: LoginViaEmailParams) async throws -> User
    func register(withEmail user: RegisterViaEmailParams) async throws -> User
}

struct LoginViaEmailParams: Encodable {
    var email: String
    var password: String
}

struct RegisterViaEmailParams: Encodable {
    var username: String
    var email: String
    var password: String
}
