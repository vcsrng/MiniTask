//
//  LoanDocument.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

struct LoanDocument: Codable, Hashable, Identifiable {
    let type: String
    let url: String

    var id: String { type + url }

    // A safely-openable URL, or `nil` if `url` isn't a fully-qualified
    var resolvedURL: URL? {
        guard let candidate = URL(string: url),
              let scheme = candidate.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              candidate.host != nil else {
            return nil
        }
        return candidate
    }
}
