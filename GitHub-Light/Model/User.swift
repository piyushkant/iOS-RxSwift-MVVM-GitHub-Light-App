//
//  User.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import Foundation

struct User: Decodable {
    var id: Int = 0
    var username: String = ""
    var score: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case score
    }
}

extension User: Comparable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.id < rhs.id
    }
}
