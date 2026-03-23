//
//  ProfileViewModel.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/22/26.
//

import Foundation

@Observable
class ProfileViewModel {
    var profile: ProfileMatchedUser?
    var isLoading = false
    var errorMessage: String?

    func loadProfile(username: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await LeetCodeService.shared.fetchProfile(username: username)
            profile = result
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
