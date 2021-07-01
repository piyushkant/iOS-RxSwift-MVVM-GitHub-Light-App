//
//  RepoCell.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import UIKit

class RepoCell: BaseTableViewCell {
    static let reuseIdentifier = "RepoCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
