//
//  ContributionGraphWidget.swift
//  ContributionGraphWidget
//
//  Created by Luis Garcia on 3/27/26.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct ContributionEntry: TimelineEntry {
    let date: Date
    let dayCounts: [Date: Int]
    let isPlaceholder: Bool

    static var placeholder: ContributionEntry {
        ContributionEntry(date: .now, dayCounts: [:], isPlaceholder: true)
    }
}

// MARK: - Timeline Provider

struct ContributionTimelineProvider: TimelineProvider {
    private let username = "LUISJG57"

    func placeholder(in context: Context) -> ContributionEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (ContributionEntry) -> Void) {
        if context.isPreview {
            completion(.placeholder)
            return
        }
        Task {
            let entry = await fetchEntry()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<ContributionEntry>) -> Void) {
        Task {
            let entry = await fetchEntry()
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 2, to: .now)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func fetchEntry() async -> ContributionEntry {
        let year = Calendar.current.component(.year, from: .now)
        do {
            let dayCounts = try await LeetCodeService.shared.fetchCalendar(
                username: username, year: year
            )
            return ContributionEntry(date: .now, dayCounts: dayCounts, isPlaceholder: false)
        } catch {
            return ContributionEntry(date: .now, dayCounts: [:], isPlaceholder: false)
        }
    }
}

// MARK: - Widget Definition

struct LeetCodeContributionWidget: Widget {
    let kind = "LeetCodeContributionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributionTimelineProvider()) { entry in
            ContributionWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("LeetCode Contributions")
        .description("Your LeetCode submission history at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    LeetCodeContributionWidget()
} timeline: {
    ContributionEntry.placeholder
    ContributionEntry(date: .now, dayCounts: [:], isPlaceholder: false)
}
