//
//  ContentView.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/12/26.
//

import SwiftUI

struct ContentView: View {
    let username = "LUISJG57"
    @State private var profileViewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ProfileView(viewModel: profileViewModel)

                ContributionGraphWidget()
            }
        }
        .task {
            await profileViewModel.loadProfile(username: username)
        }
    }
}

#Preview {
    ContentView()
}
