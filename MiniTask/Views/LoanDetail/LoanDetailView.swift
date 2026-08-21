//
//  LoanDetailView.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct LoanDetailView: View {
    let viewModel: LoanDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroHeader

                cardSection(title: "Borrower", systemImage: "person.fill") {
                    InfoRow(label: "Name",        value: viewModel.borrowerName,  systemImage: "person")
                    InfoRow(label: "Email",       value: viewModel.borrowerEmail, systemImage: "envelope")
                    InfoRow(
                        label: "Credit Score",
                        value: viewModel.creditScoreText,
                        systemImage: "chart.bar.fill",
                        valueColor: creditScoreColor
                    )
                }

                cardSection(title: "Loan Details", systemImage: "doc.text.fill") {
                    InfoRow(label: "Amount",        value: viewModel.amountText,      systemImage: "banknote")
                    InfoRow(label: "Interest Rate", value: viewModel.interestRateText, systemImage: "percent")
                    InfoRow(label: "Term",          value: viewModel.termText,          systemImage: "calendar")
                    InfoRow(label: "Purpose",       value: viewModel.loan.purpose,     systemImage: "briefcase")
                    HStack(spacing: 10) {
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        Text("Risk Rating")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        RiskBadge(rating: viewModel.loan.riskRating)
                    }
                    .padding(.vertical, 2)
                }

                cardSection(title: "Collateral", systemImage: "building.columns.fill") {
                    InfoRow(label: "Type",  value: viewModel.collateralTypeText,  systemImage: "tag")
                    InfoRow(label: "Value", value: viewModel.collateralValueText, systemImage: "dollarsign.circle")
                }

                repaymentCard

                documentsNavigationCard
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.borrowerName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [riskColor.opacity(0.7), riskColor.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                Text(initials)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(viewModel.borrowerName)
                    .font(.title3.bold())
                Text(viewModel.loan.purpose)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                RiskBadge(rating: viewModel.loan.riskRating)
            }

            HStack(spacing: 0) {
                quickStat(label: "Amount", value: viewModel.amountText)
                Divider().frame(height: 36)
                quickStat(label: "Term", value: viewModel.termText)
                Divider().frame(height: 36)
                quickStat(label: "Rate", value: viewModel.interestRateText)
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func quickStat(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func cardSection<Content: View>(
        title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                content()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    private var repaymentCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Repayment Schedule", systemImage: "calendar.badge.clock")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            if viewModel.installments.isEmpty {
                Text("No repayment schedule available.")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(Array(viewModel.installments.enumerated()), id: \.offset) { index, installment in
                    HStack {
                        Circle()
                            .fill(index == 0 ? Color.accentColor : Color(.systemGray4))
                            .frame(width: 8, height: 8)

                        Text(dateText(for: installment))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(amountText(for: installment))
                            .font(.subheadline.weight(.semibold))
                    }

                    if index < viewModel.installments.count - 1 {
                        Divider().padding(.leading, 16)
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    private var documentsNavigationCard: some View {
        NavigationLink {
            LoanDocumentsView(documents: viewModel.documents)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "doc.text.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 36, height: 36)
                    .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Loan Documents")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(viewModel.documents.isEmpty ? "No documents" : "\(viewModel.documents.count) document(s) available")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var initials: String {
        viewModel.borrowerName
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
    }

    private var riskColor: Color {
        switch viewModel.loan.riskRating.uppercased() {
        case "A": return .green
        case "B": return .orange
        case "C": return .red
        default:  return .gray
        }
    }

    private var creditScoreColor: Color {
        let score = viewModel.loan.borrower.creditScore
        if score >= 740 { return .green }
        if score >= 670 { return .orange }
        return .red
    }

    private func dateText(for installment: Installment) -> String {
        guard let date = installment.dueDateValue else { return installment.dueDate }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func amountText(for installment: Installment) -> String {
        installment.amountDue.formatted(.currency(code: AppConfig.currencyCode).precision(.fractionLength(0)))
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        LoanDetailView(viewModel: LoanDetailViewModel(loan: .preview))
    }
}
#endif
