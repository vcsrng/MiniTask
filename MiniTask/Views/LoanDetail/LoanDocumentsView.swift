//
//  LoanDocumentsView.swift
//  MiniTask
//
//  Created by Vincent Saranang on 21/08/26.
//

import SwiftUI

struct LoanDocumentsView: View {
    let documents: [LoanDocument]

    var body: some View {
        Group {
            if documents.isEmpty {
                ContentUnavailableView(
                    "No Documents",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("No documents have been uploaded for this loan yet.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "doc.on.doc.fill")
                                .foregroundStyle(.blue)
                            Text("\(documents.count) Document\(documents.count == 1 ? "" : "s")")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemGroupedBackground))

                        Divider()

                        VStack(spacing: 0) {
                            ForEach(Array(documents.enumerated()), id: \.element.id) { index, document in
                                documentRow(for: document)

                                if index < documents.count - 1 {
                                    Divider().padding(.leading, 60)
                                }
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Documents")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func documentRow(for document: LoanDocument) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: iconName(for: document.type))
                    .foregroundStyle(.blue)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(document.type)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                if document.resolvedURL != nil {
                    Label("Tap to open", systemImage: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundStyle(.blue)
                } else {
                    Text("Preview unavailable")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .background(content: {
            if let url = document.resolvedURL {
                Link(destination: url) {
                    Color.clear
                }
            }
        })
    }

    private func iconName(for type: String) -> String {
        let lowercased = type.lowercased()
        if lowercased.contains("income") || lowercased.contains("salary") {
            return "doc.text.fill"
        } else if lowercased.contains("tax") {
            return "building.columns.fill"
        } else if lowercased.contains("bank") || lowercased.contains("statement") {
            return "banknote.fill"
        } else if lowercased.contains("id") || lowercased.contains("identity") {
            return "person.text.rectangle.fill"
        } else {
            return "doc.richtext.fill"
        }
    }
}

#if DEBUG
#Preview("With documents") {
    NavigationStack {
        LoanDocumentsView(documents: Loan.preview.documents)
    }
}

#Preview("Empty") {
    NavigationStack {
        LoanDocumentsView(documents: [])
    }
}
#endif
