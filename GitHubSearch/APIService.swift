//
//  APIService.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation
import Combine

class APIService {

    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    let userSearchBaseURL = "https://api.github.com/search/users" // for search.
    let userInfoBaseURL = "https://api.github.com/users/" // for userInfo.
    let githubAuthToken = "" // [!] paste github auth token.

    // fetch userID's from API
    func fetchUsers(query: String) -> AnyPublisher<[FetchedUser], Error> {
        let parameters = ["q":query]
        
        guard let baseURL = URL(string: userSearchBaseURL) else {
            fatalError("Invalid URL")
        }
        
        let url = URLHelper.url(byAdding: parameters, to: baseURL)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map{ $0.items }
            .eraseToAnyPublisher()
    }
    
    // fetch user data from ID's
    func getUserData(with user: FetchedUser) -> AnyPublisher<User, Error> {
        let userInfoUrl = userInfoBaseURL + user.login
        guard let url = URL(string: userInfoUrl) else { fatalError("Wrong URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        if !githubAuthToken.isEmpty {
            request.setValue("Bearer \(githubAuthToken)", forHTTPHeaderField: "Authorization")
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map{$0.data}
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Combine getting ID's + getting user data
    func getAllUserData(query: String) -> AnyPublisher<[User], Error> {
        fetchUsers(query: query).flatMap { fetchedUsers in
            Publishers.Sequence(sequence: fetchedUsers.map { self.getUserData(with: $0) })
                .flatMap{$0}
                .collect()
            
        }.eraseToAnyPublisher()
    }

    // fetch repositories
    func getRepositories(repositoryURL: URL) -> AnyPublisher<[Repository], Error> {
        return URLSession.shared.dataTaskPublisher(for: repositoryURL)
            .receive(on: RunLoop.main)
            .map{$0.data}
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
