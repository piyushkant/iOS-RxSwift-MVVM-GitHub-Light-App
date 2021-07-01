//
//  UILabel+Ex.swift
//  Moneytree-Light
//
//  Created by Piyush Kant on 2021/06/23.
//

import UIKit

extension UILabel {
    func addAccessibility(label: String, hint: String, value: String = "") {
        self.isAccessibilityElement = true
        self.accessibilityTraits = .staticText
        self.accessibilityLabel = "Balance"
        self.accessibilityHint = "Shows current total balance in yen"
        self.accessibilityValue = value
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
    }
}
