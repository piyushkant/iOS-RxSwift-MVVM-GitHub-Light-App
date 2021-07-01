//
//  BaseTableViewCell.swift
//  Moneytree-Light
//
//  Created by Piyush Kant on 2021/06/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let detail = self.detailTextLabel {
            detail.sizeToFit()
            
            let rightMargin: CGFloat = 16
            
            let detailWidth = rightMargin + detail.frame.size.width
            detail.frame.origin.x = self.frame.size.width - detailWidth
            detail.frame.size.width = detailWidth
            detail.textAlignment = .left
            
            if let text = self.textLabel {
                if text.frame.origin.x + text.frame.size.width > self.frame.width - detailWidth {
                    text.frame.size.width = self.frame.width - detailWidth - text.frame.origin.x
                }
            }
        }
    }
}
