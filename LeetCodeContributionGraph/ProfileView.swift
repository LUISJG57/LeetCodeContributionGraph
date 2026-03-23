//
//  ProfileView.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/22/26.
//

import SwiftUI

struct ProfileView: View {
    var viewModel: ProfileViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading profile...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding()
            } else if let user = viewModel.profile {
                profileContent(user)
            }
        }
    }

    @ViewBuilder
    private func profileContent(_ user: ProfileMatchedUser) -> some View {
        VStack(spacing: 16) {
            // Avatar + Name
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: user.profile.userAvatar)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color(.systemGray4))
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.profile.realName)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("@\(user.username)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if let country = user.profile.countryName {
                        Text(country)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)

            // Stats row
            HStack(spacing: 24) {
                statItem(value: "\(user.profile.ranking)", label: "Ranking")
                statItem(value: "\(user.profile.reputation)", label: "Reputation")
                statItem(value: "\(user.profile.solutionCount)", label: "Solutions")
            }
            .padding(.horizontal)

            // About Me
            if !user.profile.aboutMe.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("About")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(user.profile.aboutMe)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }

            // Job / Company / School
            let details = jobDetails(user.profile)
            if !details.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(details, id: \.self) { detail in
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }

            // Skill Tags
            if !user.profile.skillTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(user.profile.skillTags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Social Links
            let links = socialLinks(user)
            if !links.isEmpty {
                HStack(spacing: 16) {
                    ForEach(links, id: \.url) { link in
                        Link(link.label, destination: URL(string: link.url)!)
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
            }

            // Websites
            if !user.profile.websites.isEmpty {
                HStack(spacing: 16) {
                    ForEach(user.profile.websites, id: \.self) { site in
                        if let url = URL(string: site) {
                            Link(url.host ?? site, destination: url)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func jobDetails(_ profile: UserProfile) -> [String] {
        var results: [String] = []
        if let jobTitle = profile.jobTitle, !jobTitle.isEmpty {
            if let company = profile.company, !company.isEmpty {
                results.append("\(jobTitle) at \(company)")
            } else {
                results.append(jobTitle)
            }
        } else if let company = profile.company, !company.isEmpty {
            results.append(company)
        }
        if let school = profile.school, !school.isEmpty {
            results.append(school)
        }
        return results
    }

    private struct SocialLink {
        let label: String
        let url: String
    }

    private func socialLinks(_ user: ProfileMatchedUser) -> [SocialLink] {
        var links: [SocialLink] = []
        if let github = user.githubUrl, !github.isEmpty {
            links.append(SocialLink(label: "GitHub", url: github))
        }
        if let twitter = user.twitterUrl, !twitter.isEmpty {
            links.append(SocialLink(label: "Twitter", url: twitter))
        }
        if let linkedin = user.linkedinUrl, !linkedin.isEmpty {
            links.append(SocialLink(label: "LinkedIn", url: linkedin))
        }
        return links
    }
}

#Preview {
    @Previewable @State var viewModel: ProfileViewModel = {
        let vm = ProfileViewModel()
        vm.profile = ProfileMatchedUser(
            username: "LUISJG57",
            githubUrl: "https://github.com/LUISJG57",
            twitterUrl: nil,
            linkedinUrl: "https://linkedin.com/in/luisjg57",
            profile: UserProfile(
                ranking: 450_123,
                userAvatar: "https://assets.leetcode.com/users/default_avatar.jpg",
                realName: "Luis Garcia",
                aboutMe: "iOS developer who enjoys solving algorithmic challenges.",
                school: "University",
                websites: ["https://luisjg.dev"],
                countryName: "Mexico",
                company: nil,
                jobTitle: "iOS Developer",
                skillTags: ["Swift", "Algorithms", "Data Structures", "iOS"],
                reputation: 42,
                solutionCount: 15
            )
        )
        return vm
    }()
    ProfileView(viewModel: viewModel)
}
