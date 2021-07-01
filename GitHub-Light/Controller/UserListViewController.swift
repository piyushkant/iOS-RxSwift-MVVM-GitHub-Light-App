//
//  UserListViewController.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import UIKit

class UserListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationBar(with: AppConfig.appName, prefersLargeTitles: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}
