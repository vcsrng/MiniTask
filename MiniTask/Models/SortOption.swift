//
//  SortOption.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case defaultOrder = "Default"
    case amountHighToLow = "Amount (High to Low)"
    case amountLowToHigh = "Amount (Low to High)"
    case termLongToShort = "Term (Long to Short)"
    case termShortToLong = "Term (Short to Long)"
    case purposeAZ = "Purpose (A–Z)"
    case purposeZA = "Purpose (Z–A)"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .defaultOrder:
            return "line.3.horizontal"
        case .amountHighToLow, .termLongToShort, .purposeZA:
            return "arrow.down"
        case .amountLowToHigh, .termShortToLong, .purposeAZ:
            return "arrow.up"
        }
    }
}
