//
//  ViewContributionGrpah.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/12/26.
//

import SwiftUI

struct ContributionGraph: View {
    var dayCounts: [Date: Int]
    var weeks: Int = 16

    let cellSize: CGFloat = 18
    let spacing: CGFloat = 3

    private var grid: [[Int]] {
        ContributionGraphViewModel.buildGrid(from: dayCounts, weeks: weeks)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
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
            .padding()
        }
    }

    func color(for level: Int) -> Color {
        switch level {
        case 0: return Color(.systemGray5)
        case 1: return Color(hex: "#9be9a8")
        case 2: return Color(hex: "#40c463")
        case 3: return Color(hex: "#30a14e")
        default: return Color(hex: "#216e39")
        }
    }
}

struct ContributionGraphWidget: View {
    let username = "LUISJG57"
    let year = "2025"

    @State private var dayCounts: [Date: Int] = [:]
    @State private var errorMessage: String?
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            ContributionGraph(dayCounts: dayCounts)
                .padding(.top, 8)

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding()
            }
        }
        .task {
            await fetchCalendar()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: - Networking

    private func fetchCalendar() async {
        let year = Calendar.current.component(.year, from: Date())
        do {
            let result = try await LeetCodeService.shared.fetchCalendar(username: username, year: year)
            dayCounts = result
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }

    // MARK: - Auto-refresh timer (every 30 seconds)

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task {
                await fetchCalendar()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}


#Preview {
    ContributionGraphWidget()
}
