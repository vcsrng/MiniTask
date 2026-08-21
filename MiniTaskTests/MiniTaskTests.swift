//
//  MiniTaskTests.swift
//  MiniTaskTests
//
//  Created by Vincent Saranang on 21/08/26.
//

import Testing
@testable import MiniTask

// MARK: - LoanListViewModel Tests

@MainActor
struct LoanListViewModelTests {

    private func makeLoan(
        id: String = "1",
        amount: Double = 5000,
        term: Int = 12,
        purpose: String = "Business",
        riskRating: String = "A"
    ) -> Loan {
        Loan(
            id: id,
            amount: amount,
            interestRate: 1.0,
            term: term,
            purpose: purpose,
            riskRating: riskRating,
            borrower: Borrower(id: "b1", name: "Test User", email: "test@test.com", creditScore: 700),
            collateral: Collateral(type: "None", value: 0),
            documents: [],
            repaymentSchedule: RepaymentSchedule(installments: [])
        )
    }

    @Test func filterByRiskRating() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            makeLoan(id: "1", riskRating: "A"),
            makeLoan(id: "2", riskRating: "B"),
            makeLoan(id: "3", riskRating: "C")
        ]))
        await vm.loadLoans()
        vm.riskFilter = "A"

        #expect(vm.displayedLoans.count == 1)
        #expect(vm.displayedLoans.first?.riskRating == "A")
    }

    @Test func searchByBorrowerName() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            Loan(id: "1", amount: 1000, interestRate: 1, term: 6, purpose: "X", riskRating: "A",
                 borrower: Borrower(id: "b1", name: "Alice", email: "", creditScore: 700),
                 collateral: Collateral(type: "None", value: 0),
                 documents: [], repaymentSchedule: RepaymentSchedule(installments: [])),
            Loan(id: "2", amount: 2000, interestRate: 1, term: 6, purpose: "Y", riskRating: "B",
                 borrower: Borrower(id: "b2", name: "Bob", email: "", creditScore: 650),
                 collateral: Collateral(type: "None", value: 0),
                 documents: [], repaymentSchedule: RepaymentSchedule(installments: []))
        ]))
        await vm.loadLoans()
        vm.searchText = "alice"

        #expect(vm.displayedLoans.count == 1)
        #expect(vm.displayedLoans.first?.borrower.name == "Alice")
    }

    @Test func searchByPurpose() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            makeLoan(id: "1", purpose: "Education"),
            makeLoan(id: "2", purpose: "Business Expansion")
        ]))
        await vm.loadLoans()
        vm.searchText = "edu"

        #expect(vm.displayedLoans.count == 1)
        #expect(vm.displayedLoans.first?.purpose == "Education")
    }

    @Test func sortByAmountHighToLow() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            makeLoan(id: "1", amount: 3000),
            makeLoan(id: "2", amount: 1000),
            makeLoan(id: "3", amount: 5000)
        ]))
        await vm.loadLoans()
        vm.sortOption = .amountHighToLow

        let amounts = vm.displayedLoans.map(\.amount)
        #expect(amounts == [5000, 3000, 1000])
    }

    @Test func sortByTermShortToLong() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            makeLoan(id: "1", term: 120),
            makeLoan(id: "2", term: 12),
            makeLoan(id: "3", term: 60)
        ]))
        await vm.loadLoans()
        vm.sortOption = .termShortToLong

        let terms = vm.displayedLoans.map(\.term)
        #expect(terms == [12, 60, 120])
    }

    @Test func availableRiskRatingsIncludesAll() async {
        let vm = LoanListViewModel(service: MockLoanService(loans: [
            makeLoan(id: "1", riskRating: "A"),
            makeLoan(id: "2", riskRating: "B")
        ]))
        await vm.loadLoans()

        #expect(vm.availableRiskRatings.first == "All")
        #expect(vm.availableRiskRatings.contains("A"))
        #expect(vm.availableRiskRatings.contains("B"))
    }

    @Test func loadLoansErrorSetsMessage() async {
        let vm = LoanListViewModel(service: MockLoanService(error: NetworkError.invalidResponse(statusCode: 500)))
        await vm.loadLoans()

        #expect(vm.loans.isEmpty)
        #expect(vm.errorMessage != nil)
    }
}

// MARK: - LoanDetailViewModel Tests

struct LoanDetailViewModelTests {

    private func makeViewModel(
        amount: Double = 5000,
        interestRate: Double = 0.8,
        term: Int = 12,
        creditScore: Int = 700
    ) -> LoanDetailViewModel {
        let loan = Loan(
            id: "1",
            amount: amount,
            interestRate: interestRate,
            term: term,
            purpose: "Education",
            riskRating: "A",
            borrower: Borrower(id: "b1", name: "John Doe", email: "john@example.com", creditScore: creditScore),
            collateral: Collateral(type: "Real Estate", value: 100_000),
            documents: [LoanDocument(type: "Income Statement", url: "https://example.com/doc.pdf")],
            repaymentSchedule: RepaymentSchedule(installments: [
                Installment(dueDate: "2024-02-15", amountDue: 500),
                Installment(dueDate: "2024-01-15", amountDue: 500)
            ])
        )
        return LoanDetailViewModel(loan: loan)
    }

    @Test func borrowerName() {
        #expect(makeViewModel().borrowerName == "John Doe")
    }

    @Test func termText() {
        #expect(makeViewModel(term: 24).termText == "24 months")
    }

    @Test func installmentsSortedByDate() {
        let installments = makeViewModel().installments
        #expect(installments.first?.dueDate == "2024-01-15")
        #expect(installments.last?.dueDate == "2024-02-15")
    }

    @Test func documentsReturned() {
        #expect(makeViewModel().documents.count == 1)
    }
}

// MARK: - Mock

private struct MockLoanService: LoanAPIServicing {
    var loans: [Loan] = []
    var error: Error? = nil

    func fetchLoans() async throws -> [Loan] {
        if let error { throw error }
        return loans
    }
}
