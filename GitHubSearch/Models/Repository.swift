//
//  Repository.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 6/1/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let name: String
    let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case htmlURL = "html_url"
    }
}
