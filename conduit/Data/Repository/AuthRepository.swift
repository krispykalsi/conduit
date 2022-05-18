//
//  AuthRepository.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

final class AuthRepository: AuthInteractor {
    internal init(remoteDataSource: DataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    private let remoteDataSource: DataSource
    
    func login(withEmail params: LoginViaEmailParams) async -> Result<User, Error> {
        await Task { try await remoteDataSource.login(withEmail: params) }.result
    }
    
    func register(withEmail params: RegisterViaEmailParams) async -> Result<User, Error> {
        await Task { try await remoteDataSource.register(withEmail: params) }.result
    }
}
