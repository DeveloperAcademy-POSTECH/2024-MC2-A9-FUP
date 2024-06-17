//
//  TabView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI

struct ContentTabView: View {
    @State var selectedTab: Int = 1
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChallengeView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("챌린지")
                }
                .tag(1)
            HistoryView()
                .tabItem {
                    Image(systemName: "scroll")
                    Text("히스토리")
                }
                .tag(2)
        }
        .tint(Theme.point)
        .onAppear {
            HapticManager.shared.resetHapticEngine()
        }
        .onChange(of: selectedTab) { _, _ in
            HapticManager.shared.generateHaptic(.medium(times: 1))
        }
    }
}

#Preview {
    ContentTabView()
        .modelContainer(for: History.self, inMemory: true)
        .environment(AVFoundationManager())
        .environment(SwiftDataManager())
}
