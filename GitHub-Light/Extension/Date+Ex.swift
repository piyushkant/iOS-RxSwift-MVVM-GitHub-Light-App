//
//  Date+Ex.swift
//  Moneytree-Light
//
//  Created by Piyush Kant on 2021/06/20.
//

import Foundation

extension Date {
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        
        return month
    }
    
    var year: Int {
        let calendar = Calendar.current
        let month = calendar.component(.year, from: self)
        
        return month
    }
    
    var currentDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.string(from: self).toDate()
    }
}
