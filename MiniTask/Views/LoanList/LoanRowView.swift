//
//  LoanRowView.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct LoanRowView: View {
    let loan: Loan

    var body: some View {
        HStack(spacing: 0) {
            // Left risk-color accent bar
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(riskColor)
                .frame(width: 4)
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 8) {
                // Top row: name + risk badge
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(loan.borrower.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(loan.purpose)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    RiskBadge(rating: loan.riskRating)
                }

                Divider()

                // Bottom row: amount, term, interest, documents
                HStack(spacing: 0) {
                    metricView(
                        label: "Amount",
                        value: amountText,
                        systemImage: "banknote"
                    )
                    Divider().frame(height: 32)
                    metricView(
                        label: "Term",
                        value: "\(loan.term) mo",
                        systemImage: "calendar"
                    )
                    Divider().frame(height: 32)
                    metricView(
                        label: "Rate",
                        value: interestRateText,
                        systemImage: "percent"
                    )
                    if !loan.documents.isEmpty {
                        Divider().frame(height: 32)
                        metricView(
                            label: "Docs",
                            value: "\(loan.documents.count)",
                            systemImage: "doc.text"
                        )
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(.background, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    private func metricView(label: String, value: String, systemImage: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: systemImage)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }

    private var riskColor: Color {
        switch loan.riskRating.uppercased() {
        case "A": return .green
        case "B": return .orange
        case "C": return .red
        default:  return .gray
        }
    }

    private var amountText: String {
        loan.amount.formatted(.currency(code: AppConfig.currencyCode).precision(.fractionLength(0)))
    }

    private var interestRateText: String {
        "\(loan.interestRate.formatted(.number.precision(.fractionLength(0...2))))%"
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 12) {
            LoanRowView(loan: .preview)
            LoanRowView(loan: .previewNoDocuments)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
#endif
