//
//  user_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol ProfileInteractor {
    func fetchCurrentUser() async throws -> User
    func updateUser(with params: UpdateUserParams) async throws -> User
    func fetchProfile(with username: String) async throws -> Profile
    func followProfile(with username: String) async throws -> Profile
    func unfollowProfile(with username: String) async throws -> Profile
}

struct UpdateUserParams: Codable {
    var email: String?
    var token: String?
    var username: String?
    var bio: String?
    var image: String?
}
