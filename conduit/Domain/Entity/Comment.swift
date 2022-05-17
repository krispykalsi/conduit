//
//  comment.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct Comment: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let body: String
    let author: Profile
}
