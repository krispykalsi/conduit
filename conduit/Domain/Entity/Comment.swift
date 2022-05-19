//
//  comment.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct Comment: Codable {
    var id: String
    var createdAt: String
    var updatedAt: String
    var body: String
    var author: Profile
}
