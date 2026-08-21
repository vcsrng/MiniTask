//
//  LoanAPIServicing.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

protocol LoanAPIServicing {
    func fetchLoans() async throws -> [Loan]
}
