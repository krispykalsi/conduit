//
//  profile.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct Profile: Codable {
    var username: String
    var bio: String?
    var image: String
    var following: Bool
}
