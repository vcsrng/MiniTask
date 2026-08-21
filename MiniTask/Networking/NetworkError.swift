//
//  NetworkError.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case transportError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse(let statusCode):
            return "The server returned an unexpected response (status \(statusCode))."
        case .decodingFailed:
            return "The loan data couldn't be read. It may be in an unexpected format."
        case .transportError(let error):
            return error.localizedDescription
        }
    }
}
