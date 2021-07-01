//
//  RepoListViewModel.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import RxSwift
import RxCocoa

protocol RepoListViewModelProtocol {
    
    // MARK: - Outputs
    var repos: BehaviorRelay<[Repo]> { get }
    var reposError: PublishRelay<APIError> { get }
}

class RepoListViewModel: RepoListViewModelProtocol {
    let disposeBag = DisposeBag()
    
    let repos = BehaviorRelay<[Repo]>.init(value: [])
    let reposError = PublishRelay<APIError>()
    
    init(user: User, service: GitHubServiceProtocol) {
        let result = service.fetchRepos(username: user.username)
            .materialize()
            .observe(on: MainScheduler.instance)
            .share(replay: 1)
        
        result
            .compactMap { $0.element }
            .bind(to: repos)
            .disposed(by: disposeBag)
        
        result
            .compactMap { $0.error as? APIError }
            .bind(to: reposError)
            .disposed(by: disposeBag)
        
    }
}
