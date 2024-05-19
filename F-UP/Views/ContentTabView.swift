//
//  TabView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI

struct ContentTabView: View {
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.18, green: 0.73, blue: 0.7, alpha: 1)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.18, green: 0.73, blue: 0.7, alpha: 1)
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        // 기본 탭바 appearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // 스크롤 시 탭바 appearance
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
