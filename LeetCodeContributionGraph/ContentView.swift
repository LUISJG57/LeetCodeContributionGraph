//
//  ContentView.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/12/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    private var dayCounts: [Date: Int] {
        let calendar = Calendar.current
        var counts: [Date: Int] = [:]
        for item in items {
            let dayStart = calendar.startOfDay(for: item.timestamp)
            counts[dayStart, default: 0] += 1
        }
        return counts
    }

    var body: some View {
        VStack(spacing: 0) {
            ContributionGraph(dayCounts: dayCounts)
                .padding(.top, 8)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
