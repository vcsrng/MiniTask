//
//  StatCard.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String
    var accentColor: Color = .blue

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(accentColor.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    HStack {
        StatCard(title: "Total Loans", value: "12", systemImage: "doc.plaintext", accentColor: .blue)
        StatCard(title: "Portfolio", value: "$480K", systemImage: "banknote", accentColor: .green)
    }
    .padding()
}
