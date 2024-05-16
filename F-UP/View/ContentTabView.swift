//
//  TabView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI

struct ContentTabView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            ChallengeView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("챌린지")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "scroll")
                    Text("히스토리")
                }
        }
    }
}

#Preview {
    ContentTabView()
}
