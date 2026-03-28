//
//  ContributionWidgetEntryView.swift
//  ContributionGraphWidget
//
//  Created by Luis Garcia on 3/27/26.
//

import SwiftUI
import WidgetKit

struct ContributionWidgetEntryView: View {
    var entry: ContributionEntry

    @Environment(\.widgetFamily) var family

    private var weeks: Int {
        switch family {
        case .systemMedium: return 16
        case .systemLarge:  return 20
        default:            return 16
        }
    }

    private var cellSize: CGFloat {
        switch family {
        case .systemMedium: return 12
        case .systemLarge:  return 14
        default:            return 12
        }
    }

    private let spacing: CGFloat = 2

    private var grid: [[Int]] {
        ContributionGraphViewModel.buildGrid(from: entry.dayCounts, weeks: weeks)
    }

    var body: some View {
        if entry.isPlaceholder {
            contributionGridView
                .redacted(reason: .placeholder)
        } else {
            contributionGridView
        }
    }

    private var contributionGridView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("LeetCode")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack(spacing: spacing) {
                ForEach(0..<weeks, id: \.self) { week in
                    VStack(spacing: spacing) {
                        ForEach(0..<7, id: \.self) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color(for: grid[week][day]))
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
        }
    }

    private func color(for level: Int) -> Color {
        switch level {
        case 0: return Color(.systemGray5)
        case 1: return Color(hex: "#9be9a8")
        case 2: return Color(hex: "#40c463")
        case 3: return Color(hex: "#30a14e")
        default: return Color(hex: "#216e39")
        }
    }
}
