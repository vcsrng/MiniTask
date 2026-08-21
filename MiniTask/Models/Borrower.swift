//
//  Borrower.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

struct Borrower: Codable, Hashable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}
