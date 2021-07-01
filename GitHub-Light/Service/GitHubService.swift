//
//  Service.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import RxSwift

protocol GitHubServiceProtocol {
    func fetchUsers(query: String, perPage: Int) -> Observable<[User]>
    func fetchRepos(username: String) -> Observable<[Repo]>
}

class GitHubService: GitHubServiceProtocol {

    let API: APIProtocol
    
    init(API: APIProtocol) {
        self.API = API
    }
   
    func fetchUsers(query: String, perPage: Int) -> Observable<[User]> {
        return API.getUsers(query: query, perPage: perPage)
            .map { response in
                let users: [User] = response.items.compactMap {
                    return $0
                }
                
                return users.sorted()
            }
    }
    
    func fetchRepos(username: String) -> Observable<[Repo]> {
        return API.getRepos(username: username)
            .map { response in
                let repos = response.compactMap {
                    return $0
                }
                                
                return repos.sorted()
            }
    }
}
