//
//  comment.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

import Foundation

struct Comment: Codable {
    var id: String
    var createdAt: Date
    var updatedAt: Date
    var body: String
    var author: Profile
}
