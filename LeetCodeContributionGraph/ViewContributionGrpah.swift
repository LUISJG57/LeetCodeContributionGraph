//
//  ViewContributionGrpah.swift
//  LeetCodeContributionGraph
//
//  Created by Luis Garcia on 3/12/26.
//

import SwiftUI

struct ContributionGraph: View {
    let weeks = 16
    let days = 7
    let cellSize: CGFloat = 18
    let spacing: CGFloat = 3

    @State private var contributions:
    [[Int]] = (0..<52).map { _ in
        (0..<7).map { _ in Int.random(in: 0...4) }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(0..<weeks, id: \.self) { week in
                    VStack(spacing: spacing) {
                        ForEach(0..<days, id: \.self) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color(for: contributions[week][day]))
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
    ContributionGraph()

}
