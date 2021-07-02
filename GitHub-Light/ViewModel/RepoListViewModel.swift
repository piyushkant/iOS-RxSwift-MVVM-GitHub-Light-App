//
//  RepoListViewModel.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import RxSwift
import RxCocoa

protocol RepoListViewModelProtocol {
    
    // MARK: - Inputs
    var filterKey: BehaviorRelay<String> { get }
    var cancelButtonTapped: PublishRelay<Void> { get }
    
    // MARK: - Outputs
    var repos: BehaviorRelay<[Repo]> { get }
    var reposError: PublishRelay<APIError> { get }
}

class RepoListViewModel: RepoListViewModelProtocol {
    let disposeBag = DisposeBag()
    
    let filterKey =  BehaviorRelay<String>.init(value: "")
    let cancelButtonTapped = PublishRelay<Void>()
    
    let repos = BehaviorRelay<[Repo]>.init(value: [])
    let reposError = PublishRelay<APIError>()
    
    init(user: User, service: GitHubServiceProtocol) {
        let baseReposForFiltering = BehaviorRelay<[Repo]>.init(value: [])
        
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
        
        result
            .compactMap { $0.element }
            .bind(to: baseReposForFiltering)
            .disposed(by: disposeBag)
        
        let inputText = filterKey
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{ $0.lowercased() }
            .share()
        
        Observable.combineLatest (
            inputText,
            baseReposForFiltering
        )
        .filter { $0.0 != ""}
        .map {text, repos -> [Repo] in
            return repos.filter {
                $0.name.lowercased().contains(text)
            }
        }
        .bind(to: repos)
        .disposed(by: disposeBag)
        
        cancelButtonTapped.asObservable()
            .flatMapLatest { service.fetchRepos(username: user.username) }
            .bind(to: repos)
            .disposed(by: disposeBag)
    }
}
