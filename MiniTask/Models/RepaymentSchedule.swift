//
//  RepaymentSchedule.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import Foundation

struct RepaymentSchedule: Codable, Hashable {
    let installments: [Installment]
}

struct Installment: Codable, Hashable {
    let dueDate: String
    let amountDue: Double

    // Parses the API's `"yyyy-MM-dd"` string into a `Date` for sorting and locale-aware display. Kept as a computed property (rather than a custom `Decodable` date strategy) so a malformed date never fails the whole decode — it just falls back to showing the raw string.
    var dueDateValue: Date? {
        Self.apiDateFormatter.date(from: dueDate)
    }

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
