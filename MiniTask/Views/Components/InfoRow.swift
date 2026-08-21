//
//  InfoRow.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    var systemImage: String? = nil
    var valueColor: Color = .primary

    var body: some View {
        HStack(spacing: 10) {
            if let icon = systemImage {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            }
            Text(label)
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    List {
        InfoRow(label: "Name", value: "John Doe", systemImage: "person")
        InfoRow(label: "Credit Score", value: "750", systemImage: "chart.bar", valueColor: .green)
    }
}
