//
//  ContentView.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/12/26.
//

import SwiftUI

struct ContentView: View {
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

#Preview {
    ContentView()
}
