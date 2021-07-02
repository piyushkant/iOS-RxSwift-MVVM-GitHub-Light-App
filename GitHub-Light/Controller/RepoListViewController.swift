//
//  RepoListViewController.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import UIKit
import RxSwift

class RepoListViewController: UIViewController {
    var user: User!
    
    private let disposeBag = DisposeBag()
    private var viewModel: RepoListViewModelProtocol!
    
    private let searchController = UISearchController()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: \(user.id)"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: \(user.score)"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [idLabel, scoreLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        return stackView
    }()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel = RepoListViewModel(user: user!, service: GitHubService(API: API.shared))
        
        setupUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationBar(with: "Repo List", prefersLargeTitles: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupSearchController()
        setupNameLabel()
        setupInfoStackView()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search Repos"
        searchController.searchBar.tintColor = .white
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
    }
    
    private func setupNameLabel() {
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(view.frame.height/20)
        }
        
        usernameLabel.text = user?.username
    }
    
    private func setupInfoStackView() {
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(view.frame.height/20)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseIdentifier)
    }
    
    private func bind() {
        
        // MARK: - Inputs
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.filterKey)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .bind(to: viewModel.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        // MARK: - Outputs
        viewModel.repos
            .bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseIdentifier, cellType: RepoCell.self)) { (_, repo, cell) in
                cell.selectionStyle = .none
                
                let textLabel = cell.textLabel
                textLabel?.text = repo.name
                textLabel?.textColor = .gray
                textLabel?.font = .systemFont(ofSize: 18)
                
                let detialLabel = cell.detailTextLabel
                detialLabel?.text = "\(repo.id)"
                detialLabel?.textColor = .gray
                detialLabel?.font = .systemFont(ofSize: 18)
            }
            .disposed(by: disposeBag)
        
        viewModel.reposError
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }
}
