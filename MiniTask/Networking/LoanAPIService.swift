//
//  LoanAPIService.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

struct LoanAPIService: LoanAPIServicing {
    static let defaultEndpoint = URL(
        string: "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/api/json/loans.json"
    )!

    private let endpoint: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        endpoint: URL = LoanAPIService.defaultEndpoint,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.endpoint = endpoint
        self.session = session
        self.decoder = decoder
    }

    func fetchLoans() async throws -> [Loan] {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: endpoint)
        } catch {
            throw NetworkError.transportError(error)
        }

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode([Loan].self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
