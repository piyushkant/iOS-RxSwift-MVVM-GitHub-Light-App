//
//  UserListViewController.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class UserListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: UsersViewModelProtocol!
    
    var totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UsersViewModel(service: GitHubService(API: API.shared))
        
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationBar(with: "GitHub Users", prefersLargeTitles: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupTotalScoreLabel()
        setupTableView()
    }
    
    private func setupTotalScoreLabel() {
        view.addSubview(totalScoreLabel)
        totalScoreLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(view.frame.height/5)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(totalScoreLabel.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.totalScore
            .map { "Total score: \($0)" }
            .bind(to: totalScoreLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.users
            .bind(to: tableView.rx.items(cellIdentifier: UserCell.reuseIdentifier, cellType: UserCell.self)) { (_, user, cell) in
                cell.selectionStyle = .none
                
                let textLabel = cell.textLabel
                textLabel?.text = user.username
                textLabel?.font = .boldSystemFont(ofSize: 20)
                textLabel?.textColor = .gray
                
                let detailLabel = cell.detailTextLabel
                detailLabel?.text = "\(user.score)"
                detailLabel?.font = .boldSystemFont(ofSize: 20)
                detailLabel?.textColor = .gray
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                
                let repoListVC = RepoListViewController()
                repoListVC.user = user
                self.navigationController?.pushViewController(repoListVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.usersError
            .subscribe ( onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }
}
