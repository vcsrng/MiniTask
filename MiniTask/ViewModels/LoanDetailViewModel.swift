//
//  LoanDetailViewModel.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

struct LoanDetailViewModel {
    let loan: Loan

    var borrowerName: String { loan.borrower.name }
    var borrowerEmail: String { loan.borrower.email }
    var creditScoreText: String { "\(loan.borrower.creditScore)" }

    var amountText: String { Self.currency(loan.amount) }

    var interestRateText: String {
        "\(loan.interestRate.formatted(.number.precision(.fractionLength(0...2))))%"
    }

    var termText: String { "\(loan.term) months" }

    var collateralTypeText: String { loan.collateral.type }
    var collateralValueText: String { Self.currency(loan.collateral.value) }

    var installments: [Installment] {
        loan.repaymentSchedule.installments.sorted {
            ($0.dueDateValue ?? .distantFuture) < ($1.dueDateValue ?? .distantFuture)
        }
    }

    var documents: [LoanDocument] { loan.documents }

    private static func currency(_ value: Double) -> String {
        value.formatted(.currency(code: AppConfig.currencyCode).precision(.fractionLength(0)))
    }
}
