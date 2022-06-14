//
//  IProfileRepository.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol IProfileRepository {
    func fetchProfile(with username: String) async throws -> Profile
    func followProfile(with username: String) async throws -> Profile
    func unfollowProfile(with username: String) async throws -> Profile
}
