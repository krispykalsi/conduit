//
//  IUserRepository.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 31/05/22.
//

protocol IUserRepository {
    func fetchCurrentUser() async throws -> User
    func updateUser(with params: UpdateUserParams) async throws -> User
    func login(withEmail user: LoginViaEmailParams) async throws -> User
    func register(withEmail user: RegisterViaEmailParams) async throws -> User
}

struct UpdateUserParams: Encodable {
    var email: String?
    var token: String?
    var username: String?
    var bio: String?
    var image: String?
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
