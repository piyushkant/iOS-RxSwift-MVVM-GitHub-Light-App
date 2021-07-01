//
//  String+Ex.swift
//  Moneytree-Light
//
//  Created by Piyush Kant on 2021/06/20.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
    func toMonth() -> Int {
        switch self {
        case "January":
            return 1
        case "February":
            return 2
        case "March":
            return 3
        case "April":
            return 4
        case "May":
            return 5
        case "June":
            return 6
        case "July":
            return 7
        case "August":
            return 8
        case "September":
            return 9
        case "October":
            return 10
        case "November":
            return 11
        case "December":
            return 12
        default:
            return 0
        }
    }
}

