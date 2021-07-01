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
    let disposeBag = DisposeBag()
    var viewModel: UsersViewModelProtocol!
    
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
        
        setupNavigationBar(with: AppConfig.appName, prefersLargeTitles: false)
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
        
        totalScoreLabel.text = "50.0"
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
    }
}
