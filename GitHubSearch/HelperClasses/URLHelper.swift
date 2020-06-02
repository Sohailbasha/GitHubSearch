//
//  URLHelper.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 6/1/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation

class URLHelper {

    /// Construct a url with qurty items
    static func url(byAdding parameters: [String : String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}
