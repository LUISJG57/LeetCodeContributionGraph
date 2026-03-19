//
//  MockData.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/18/26.
//

import Foundation

// LeetCode API Response Models

struct LeetCodeResponse: Codable {
    let data: LeetCodeData
}

struct LeetCodeData: Codable {
    let matchedUser: MatchedUser
}

struct MatchedUser: Codable {
    let userCalendar: UserCalendar
}

struct UserCalendar: Codable {
    let activeYears: [Int]
    let streak: Int
    let totalActiveDays: Int
    let submissionCalendar: String
}

// Mock Data

enum MockData {
    // Raw JSON matching the real LeetCode GraphQL API response format.
    static let json = """
    {
        "data": {
            "matchedUser": {
                "userCalendar": {
                    "activeYears": [2025, 2026],
                    "streak": 4,
                    "totalActiveDays": 11,
                    "dccBadges": [],
                    "submissionCalendar": "{\\"1767225600\\": 1, \\"1767484800\\": 5, \\"1767571200\\": 1, \\"1767657600\\": 1, \\"1767744000\\": 16, \\"1767916800\\": 1, \\"1772928000\\": 1, \\"1773014400\\": 2, \\"1773100800\\": 1, \\"1773187200\\": 2, \\"1773360000\\": 1}"
                }
            }
        }
    }
    """

    // Parses the mock JSON into a `LeetCodeResponse`.
    static let response: LeetCodeResponse = {
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(LeetCodeResponse.self, from: data)
    }()

    // Parses `submissionCalendar` into a dictionary of `[Date: Int]` (day -> submission count).
    static let submissionCalendar: [Date: Int] = {
        parseSubmissionCalendar(response.data.matchedUser.userCalendar.submissionCalendar)
    }()

    // Converts the `submissionCalendar` JSON string (unix timestamps as keys, counts as values) into a `[Date: Int]` dictionary keyed by the start of each day.
    static func parseSubmissionCalendar(_ calendarString: String) -> [Date: Int] {
        guard let data = calendarString.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Int] else {
            return [:]
        }

        let calendar = Calendar.current
        var result: [Date: Int] = [:]
        for (timestampString, count) in dict {
            if let timestamp = TimeInterval(timestampString) {
                let date = Date(timeIntervalSince1970: timestamp)
                let dayStart = calendar.startOfDay(for: date)
                result[dayStart, default: 0] += count
            }
        }
        return result
    }
}
