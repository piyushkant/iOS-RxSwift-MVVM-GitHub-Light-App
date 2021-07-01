//
//  RxSwift + Ex.swift
//  Moneytree-Light
//
//  Created by Piyush Kant on 2021/06/22.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
