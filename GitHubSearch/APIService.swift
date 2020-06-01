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

    let userSearchBaseURL = "https://api.github.com/search/users" // for search
    let userInfoBaseURL = "https://api.github.com/users/" // for userInfo

    func fetchUsers(query: String) -> AnyPublisher<[FetchedUser], Error> {
        let parameters = ["q":query]
        
        guard let baseURL = URL(string: userSearchBaseURL) else {
            fatalError("Invalid URL")
        }
        
        let url = self.url(byAdding: parameters, to: baseURL)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map { $0.data }
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map{ $0.items }
            .eraseToAnyPublisher()
    }
    
    func getUserData(with user: FetchedUser) -> AnyPublisher<User, Error> {
        let userInfoUrl = userInfoBaseURL + user.login
        guard let url = URL(string: userInfoUrl) else { fatalError("Wrong URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer 12286d850bdb4755ad2502f43b972a5331e1f797", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map{$0.data}
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getAllUserData(query: String) -> AnyPublisher<[User], Error> {
        fetchUsers(query: query).flatMap { fetchedUsers in
            Publishers.Sequence(sequence: fetchedUsers.map { self.getUserData(with: $0) })
                .flatMap{$0}
                .collect()
            
        }.eraseToAnyPublisher()
    }
    
    func getRepositories(repositoryURL: URL) -> AnyPublisher<[Repository], Error> {
        return URLSession.shared.dataTaskPublisher(for: repositoryURL)
            .receive(on: RunLoop.main)
            .map{$0.data}
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func url(byAdding parameters: [String : String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}
