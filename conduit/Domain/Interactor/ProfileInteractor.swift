//
//  user_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol ProfileInteractor {
    func fetchCurrentUser() async -> Result<User, Error>
    func updateUser(with params: UpdateUserParams) async -> Result<User, Error>
    func fetchProfile(with username: String) async -> Result<Profile, Error>
    func followProfile(with username: String) async -> Result<Profile, Error>
    func unfollowProfile(with username: String) async -> Result<Profile, Error>
}

struct UpdateUserParams: Codable {
    let email: String?
    let token: String?
    let username: String?
    let bio: String?
    let image: String?
}
