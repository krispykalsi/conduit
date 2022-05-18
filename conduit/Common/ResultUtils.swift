//
//  ResultUtils.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

internal func executeAndCatch<T>(_ request: () async throws -> T) async -> Result<T, Error> {
    do {
        let data = try await request()
        return Result.success(data)
    } catch {
        return Result.failure(error)
    }
}
