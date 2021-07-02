//
//  Repo.swift
//  GitHub-Light
//
//  Created by Piyush Kant on 2021/07/01.
//

import Foundation

struct Repo: Decodable {
    var id: Int = 0
    var name: String = ""
    var createdAt: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
    }
}

extension Repo: Comparable {
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        lhs.id == rhs.id
    }
    static func < (lhs: Repo, rhs: Repo) -> Bool {
        rhs.id < lhs.id
    }
}
