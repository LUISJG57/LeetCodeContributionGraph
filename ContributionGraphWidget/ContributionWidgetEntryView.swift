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
        case .systemSmall:  return 7
        case .systemMedium: return 16
        case .systemLarge:  return 16
        default:            return 16
        }
    }

    private var cellSize: CGFloat {
        switch family {
        case .systemSmall:  return 15
        case .systemMedium: return 16
        case .systemLarge:  return 16
        default:            return 16
        }
    }

    private var spacing: CGFloat {
        switch family {
        case .systemSmall:  return 4
        case .systemMedium: return 4
        case .systemLarge:  return 4
        default:            return 4
        }
    }

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
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func color(for level: Int) -> Color {
        switch level {
        case 0: return Color(.systemGray5)
        case 1: return Color(hex: "#8965C2")
        case 2: return Color(hex: "#9557BC")
        case 3: return Color(hex: "#A149B6")
        default: return Color(hex: "#AD3BB0")
        }
    }
}
