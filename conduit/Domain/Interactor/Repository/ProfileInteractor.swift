//
//  user_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol ProfileInteractor {
    func fetchProfile(with username: String) async throws -> Profile
    func followProfile(with username: String) async throws -> Profile
    func unfollowProfile(with username: String) async throws -> Profile
}
