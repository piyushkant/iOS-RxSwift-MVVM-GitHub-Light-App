//
//  API.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//


//MARK: - API Endpoint

import Alamofire
import RxSwift

enum APIEndpoint: URLRequestConvertible {
    private enum Constants {
        static let baseUrl = "https://api.github.com"
    }
    
    case users(String, Int)
    case repos(String)
    
    var method: HTTPMethod {
        switch self {
        case .users, .repos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/search/users"
        case .repos(let username):
            return "/users/\(username)/repos"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .users(let query, let perPage):
            return ["q": query, "per_page": perPage]
        case .repos:
            return[:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}

//MARK: - API Error

enum APIError: Error {
    case serverError
    case connectionError
    case unknownError
    
    var message: String {
        switch self {
        case .serverError:
            return "Server error"
        case .connectionError:
            return "Conection error"
        case.unknownError:
            return "Unknow error"
        }
    }
}

protocol APIProtocol {
    func getUsers(query: String, perPage: Int) -> Observable<Users>
    func getRepos(username: String) -> Observable<[Repo]> 
}

//MARK: - API Networking

class API: APIProtocol {
    static let shared = API()
    
    private init() {}
    
    func getUsers(query: String, perPage: Int) -> Observable<Users> {
        request(urlRequestConvertible: APIEndpoint.users(query, perPage))
    }
    
    func getRepos(username: String) -> Observable<[Repo]> {
        request(urlRequestConvertible: APIEndpoint.repos(username))
    }
    
    private func request<T>(urlRequestConvertible: URLRequestConvertible) -> Observable<T> where T: Decodable {
        return Observable.create { observer in
            
            let request = AF.request(urlRequestConvertible)
            
            print("urlRequestConvertible", urlRequestConvertible)
            
            request.responseJSON { response in
                guard let data = response.data else {
                    return observer.onError(APIError.connectionError)
                }

                if let obj = try? JSONDecoder().decode(T.self, from: data) {
                    observer.onNext(obj)
                    observer.onCompleted()
                } else {
                    observer.onError(APIError.serverError)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
