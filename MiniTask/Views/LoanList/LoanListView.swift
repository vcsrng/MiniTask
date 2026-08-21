//
//  LoanListView.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct LoanListView: View {
    @StateObject private var viewModel = LoanListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Loans")
                .navigationDestination(for: Loan.self) { loan in
                    LoanDetailView(viewModel: LoanDetailViewModel(loan: loan))
                }
                .searchable(text: $viewModel.searchText, prompt: "Search by borrower or purpose")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        sortAndFilterMenu
                    }
                }
                .task {
                    if viewModel.loans.isEmpty {
                        await viewModel.loadLoans()
                    }
                }
        }
    }


    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.loans.isEmpty {
            ProgressView("Loading loans…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage, viewModel.loans.isEmpty {
            ContentUnavailableView {
                Label("Couldn't Load Loans", systemImage: "wifi.exclamationmark")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.loadLoans() }
                }
            }
        } else if viewModel.displayedLoans.isEmpty {
            emptyState
        } else {
            loanList
        }
    }


    private var loanList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !viewModel.loans.isEmpty && viewModel.searchText.isEmpty {
                    portfolioDashboard
                        .padding(.horizontal)
                        .padding(.top, 4)
                }

                ForEach(viewModel.displayedLoans) { loan in
                    NavigationLink(value: loan) {
                        LoanRowView(loan: loan)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }

                Color.clear.frame(height: 8)
            }
            .padding(.top, 4)
        }
        .background(Color(.systemGroupedBackground))
        .refreshable { await viewModel.loadLoans() }
    }


    private var portfolioDashboard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Portfolio Overview")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                StatCard(
                    title: "Total Loans",
                    value: "\(viewModel.loans.count)",
                    systemImage: "doc.plaintext.fill",
                    accentColor: .blue
                )
                StatCard(
                    title: "Portfolio Value",
                    value: portfolioValueText,
                    systemImage: "banknote.fill",
                    accentColor: .green
                )
                StatCard(
                    title: "Avg. Interest",
                    value: avgInterestRateText,
                    systemImage: "percent",
                    accentColor: .purple
                )
                StatCard(
                    title: riskDistributionTitle,
                    value: riskDistributionText,
                    systemImage: "shield.lefthalf.filled",
                    accentColor: .orange
                )
            }
        }
    }


    @ViewBuilder
    private var emptyState: some View {
        if !viewModel.searchText.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            ContentUnavailableView {
                Label("No Loans Found", systemImage: "tray")
            } description: {
                Text("No loans match the selected risk filter.")
            } actions: {
                Button("Clear Filter") { viewModel.riskFilter = "All" }
            }
        }
    }


    private var sortAndFilterMenu: some View {
        Menu {
            Section("Filter by Risk") {
                Picker("Risk Rating", selection: $viewModel.riskFilter) {
                    ForEach(viewModel.availableRiskRatings, id: \.self) { rating in
                        Text(rating).tag(rating)
                    }
                }
            }
            Section("Sort By") {
                Picker("Sort", selection: $viewModel.sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Label(option.rawValue, systemImage: option.systemImage).tag(option)
                    }
                }
            }
        } label: {
            Label("Sort & Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }


    private var portfolioValueText: String {
        let total = viewModel.displayedLoans.reduce(0) { $0 + $1.amount }
        return total.formatted(.currency(code: AppConfig.currencyCode).precision(.fractionLength(0)))
    }

    private var avgInterestRateText: String {
        guard !viewModel.displayedLoans.isEmpty else { return "—" }
        let avg = viewModel.displayedLoans.map(\.interestRate).reduce(0, +) / Double(viewModel.displayedLoans.count)
        return "\(avg.formatted(.number.precision(.fractionLength(1))))%"
    }

    private var riskDistributionTitle: String {
        viewModel.riskFilter == "All" ? "Risk A / B / C" : "Risk \(viewModel.riskFilter)"
    }

    private var riskDistributionText: String {
        if viewModel.riskFilter != "All" {
            return "\(viewModel.displayedLoans.count)"
        }
        let a = viewModel.displayedLoans.filter { $0.riskRating.uppercased() == "A" }.count
        let b = viewModel.displayedLoans.filter { $0.riskRating.uppercased() == "B" }.count
        let c = viewModel.displayedLoans.filter { $0.riskRating.uppercased() == "C" }.count
        return "\(a) / \(b) / \(c)"
    }
}

#Preview {
    LoanListView()
}
