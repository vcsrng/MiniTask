//
//  PreviewSupport.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

#if DEBUG
// Sample data for SwiftUI `#Preview`s and unit tests. Compiled out of Release builds by the `DEBUG` guard.
extension Loan {
    static let preview = Loan(
        id: "preview-1",
        amount: 5000,
        interestRate: 0.8,
        term: 120,
        purpose: "Business Expansion",
        riskRating: "C",
        borrower: Borrower(
            id: "b1",
            name: "Shelly Valenzuela",
            email: "shellyvalenzuela@example.com",
            creditScore: 650
        ),
        collateral: Collateral(type: "Real Estate", value: 100_000),
        documents: [
            LoanDocument(type: "Income Statement", url: "/loans/documents/income_statement/slip.jpeg")
        ],
        repaymentSchedule: RepaymentSchedule(installments: [
            Installment(dueDate: "2023-01-15", amountDue: 500),
            Installment(dueDate: "2023-02-15", amountDue: 500)
        ])
    )

    static let previewNoDocuments = Loan(
        id: "preview-2",
        amount: 8000,
        interestRate: 1.2,
        term: 60,
        purpose: "Education",
        riskRating: "A",
        borrower: Borrower(
            id: "b2",
            name: "Alex Turner",
            email: "alex.turner@example.com",
            creditScore: 780
        ),
        collateral: Collateral(type: "None", value: 0),
        documents: [],
        repaymentSchedule: RepaymentSchedule(installments: [])
    )
}
#endif
