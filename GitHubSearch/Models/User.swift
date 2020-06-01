//
//  User.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let items: [FetchedUser]
}
struct FetchedUser: Codable {
    let login: String
}

struct User: Codable {
    let login: String?
    let avatarURL: String?
    let reposURL: String?
    let createdAt: String?

    let repoCount: Int?
    let followerCount: Int?
    let followingCount: Int?

    let bio: String?
    let email: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarURL = "avatar_url"
        case repoCount = "public_repos"
        case createdAt = "created_at"
        case location = "location"
        case followerCount = "followers"
        case followingCount = "following"
        case bio = "bio"
        case email = "email"
        case reposURL = "repos_url"
    }
}
