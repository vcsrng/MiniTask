//
//  Loan.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

// A single loan record returned by the Loans API.
struct Loan: Identifiable, Codable, Hashable {
    let id: String
    let amount: Double
    let interestRate: Double
    let term: Int
    let purpose: String
    let riskRating: String
    let borrower: Borrower
    let collateral: Collateral
    let documents: [LoanDocument]
    let repaymentSchedule: RepaymentSchedule
}
