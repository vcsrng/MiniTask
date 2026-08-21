//
//  LoanListViewModel.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Combine
import Foundation

@MainActor
final class LoanListViewModel: ObservableObject {
    @Published private(set) var loans: [Loan] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .defaultOrder
    @Published var riskFilter: String = "All"

    private let service: LoanAPIServicing

    init(service: LoanAPIServicing = LoanAPIService()) {
        self.service = service
    }

    var availableRiskRatings: [String] {
        ["All"] + Set(loans.map(\.riskRating)).sorted()
    }

    var displayedLoans: [Loan] {
        var result = loans

        if riskFilter != "All" {
            result = result.filter { $0.riskRating == riskFilter }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            result = result.filter {
                $0.borrower.name.localizedCaseInsensitiveContains(query) ||
                $0.purpose.localizedCaseInsensitiveContains(query)
            }
        }

        switch sortOption {
        case .defaultOrder:
            break
        case .amountHighToLow:
            result.sort { $0.amount > $1.amount }
        case .amountLowToHigh:
            result.sort { $0.amount < $1.amount }
        case .termLongToShort:
            result.sort { $0.term > $1.term }
        case .termShortToLong:
            result.sort { $0.term < $1.term }
        case .purposeAZ:
            result.sort { $0.purpose.localizedCompare($1.purpose) == .orderedAscending }
        case .purposeZA:
            result.sort { $0.purpose.localizedCompare($1.purpose) == .orderedDescending }
        }

        return result
    }

    func loadLoans() async {
        isLoading = true
        errorMessage = nil
        do {
            loans = try await service.fetchLoans()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
