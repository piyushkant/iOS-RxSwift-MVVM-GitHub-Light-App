//
//  UsersViewModel.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import RxSwift
import RxCocoa

protocol UsersViewModelProtocol {
    
    // MARK: - Outputs
    var users: BehaviorRelay<[User]> { get }
    var usersError: PublishRelay<APIError> { get }
    var totalScore: BehaviorRelay<Double> { get }
}

class UsersViewModel: UsersViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    let users = BehaviorRelay<[User]>.init(value: [])
    let usersError = PublishRelay<APIError>()
    let totalScore = BehaviorRelay<Double>.init(value: 0.0)
    
    init(service: GitHubServiceProtocol) {
        let result = service.fetchUsers(query: AppConfig.query, perPage: AppConfig.perPage)
            .materialize()
            .observe(on: MainScheduler.instance)
            .share(replay: 1)
        
        result
            .compactMap { $0.element }
            .bind(to: users)
            .disposed(by: disposeBag)
        
        result
            .compactMap { $0.error as? APIError }
            .bind(to: usersError)
            .disposed(by: disposeBag)
        
        result
            .compactMap { $0.element.flatMap { Observable.from($0) } }
            .flatMap { $0.map { $0.score } }
            .reduce(0, accumulator: +)
            .bind(to: totalScore)
            .disposed(by: disposeBag)
    }
}
