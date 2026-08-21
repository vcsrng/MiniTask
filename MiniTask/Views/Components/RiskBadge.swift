//
//  RiskBadge.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct RiskBadge: View {
    let rating: String

    var body: some View {
        Text(rating)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(color)
            .background(color.opacity(0.15), in: Capsule())
            .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 0.5))
    }

    var color: Color {
        switch rating.uppercased() {
        case "A": return .green
        case "B": return .orange
        case "C": return .red
        default:  return .gray
        }
    }
}

#Preview {
    HStack {
        RiskBadge(rating: "A")
        RiskBadge(rating: "B")
        RiskBadge(rating: "C")
        RiskBadge(rating: "Z")
    }
    .padding()
}
