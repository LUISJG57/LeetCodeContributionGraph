//
//  LeetcodeResponseModel.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/21/26.
//

import Foundation

// MARK: - Response Models

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
    let submissionCalendar: String
}

// MARK: - Service

struct LeetCodeService {
    static let shared = LeetCodeService()

    /// Fetches the submission calendar for a public LeetCode profile.
    func fetchCalendar(username: String, year: Int) async throws -> [Date: Int] {
        let url = URL(string: "https://leetcode.com/graphql/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("https://leetcode.com", forHTTPHeaderField: "Referer")

        let query = """
        query userProfileCalendar($username: String!, $year: Int) {
          matchedUser(username: $username) {
            userCalendar(year: $year) {
              submissionCalendar
            }
          }
        }
        """
        let body: [String: Any] = [
            "query": query,
            "variables": ["username": username, "year": String(year)]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(LeetCodeResponse.self, from: data)
        return Self.parseSubmissionCalendar(decoded.data.matchedUser.userCalendar.submissionCalendar)
    }

    // Converts the `submissionCalendar` JSON string (unix timestamp keys, count values) into a `[Date: Int]` dictionary keyed by start of day.
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
