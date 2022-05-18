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
        return await executeAndCatch {
            return try await remoteDataSource.fetchCurrentUser()
        }
    }
    
    func updateUser(with params: UpdateUserParams) async -> Result<User, Error> {
        return await executeAndCatch {
            return try await remoteDataSource.updateUser(with: params)
        }
    }
    
    func fetchProfile(with username: String) async -> Result<Profile, Error> {
        return await executeAndCatch({
            return try await remoteDataSource.fetchProfile(with: username)
        })
    }
    
    func followProfile(with username: String) async -> Result<Profile, Error> {
        return await executeAndCatch({
            return try await remoteDataSource.followProfile(with: username)
        })
    }
    
    func unfollowProfile(with username: String) async -> Result<Profile, Error> {
        return await executeAndCatch({
            return try await remoteDataSource.unfollowProfile(with: username)
        })
    }
}
