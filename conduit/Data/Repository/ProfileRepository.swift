//
//  ProfileRepository.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

final class ProfileRepository: ProfileInteractor {
    internal init(remoteDataSource: DataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    private let remoteDataSource: DataSource
    
    func fetchCurrentUser() async -> Result<User, Error> {
        await Task { try await remoteDataSource.fetchCurrentUser() }.result
    }
    
    func updateUser(with params: UpdateUserParams) async -> Result<User, Error> {
        await Task { try await remoteDataSource.updateUser(with: params) }.result
    }
    
    func fetchProfile(with username: String) async -> Result<Profile, Error> {
        await Task { try await remoteDataSource.fetchProfile(with: username) }.result
    }
    
    func followProfile(with username: String) async -> Result<Profile, Error> {
        await Task { try await remoteDataSource.followProfile(with: username) }.result
    }
    
    func unfollowProfile(with username: String) async -> Result<Profile, Error> {
        await Task { try await remoteDataSource.unfollowProfile(with: username) }.result
    }
}
