//
//  UserInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 31/05/22.
//

protocol UserInteractor {
    func fetchCurrentUser() async throws -> User
    func updateUser(with params: UpdateUserParams) async throws -> User
}

struct UpdateUserParams: Codable {
    var email: String?
    var token: String?
    var username: String?
    var bio: String?
    var image: String?
}
