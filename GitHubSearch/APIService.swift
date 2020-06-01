//
//  APIService.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation

class APIService {

    let stringURL = "https://api.github.com/search/users" // for search
    let userInfoURL = "https://api.github.com/users/" // for userInfo
    

    static func url(bbyAdding parameters: [String : String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}
