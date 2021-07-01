//
//  UIViewController+Ex.swift
//  CurrencyLayer
//
//  Created by Piyush Kant on 2021/06/05.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBar(with title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = AppConfig.appThemeColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
//    func showErrorAlert(_ error: APIError) {
//        self.showAlert(title: "Error", message: error.message, actions: [UIAlertAction(title: "OK", style: .default)])
//    }
    
    func showAlert(title: String?, message: String?,actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
