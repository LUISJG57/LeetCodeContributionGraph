//
//  ContributionGraphViewModel.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/18/26.
//

import Foundation

enum ContributionGraphViewModel {
    // Builds a [week][day] grid where week 0 is the oldest and the last week is the current one (containing today). day 0 = Sunday ... day 6 = Saturday.
    static func buildGrid(from dayCounts: [Date: Int], weeks: Int) -> [[Int]] {
        let calendar = Calendar.current
        let today = Date()

        // Start of the current week (Sunday)
        guard let currentWeekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return Array(repeating: Array(repeating: 0, count: 7), count: weeks)
        }
        let startOfCurrentWeek = currentWeekInterval.start

        // The graph starts (weeks - 1) full weeks before the current week
        guard let graphStart = calendar.date(byAdding: .weekOfYear, value: -(weeks - 1), to: startOfCurrentWeek) else {
            return Array(repeating: Array(repeating: 0, count: 7), count: weeks)
        }

        // Populate the grid
        var grid = Array(repeating: Array(repeating: 0, count: 7), count: weeks)
        for week in 0..<weeks {
            for day in 0..<7 {
                guard let date = calendar.date(byAdding: .day, value: week * 7 + day, to: graphStart) else { continue }
                if date > today { continue }
                let dayStart = calendar.startOfDay(for: date)
                let count = dayCounts[dayStart] ?? 0
                grid[week][day] = intensityLevel(for: count)
            }
        }

        return grid
    }

    // Maps a raw contribution count to a 0-4 intensity level.
    static func intensityLevel(for count: Int) -> Int {
        switch count {
        case 0:    return 0
        case 1:    return 1
        case 2:    return 2
        case 3:    return 3
        default:   return 4
        }
    }
}
