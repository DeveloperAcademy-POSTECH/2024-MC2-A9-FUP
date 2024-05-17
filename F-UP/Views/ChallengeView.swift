//
//  ChallengeView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI

struct ChallengeView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(Theme.point)
                    .frame(height: 200)
                    .padding(Theme.padding)
                    .dropShadow(opacity: 0.5)
            }
            
        }
    }
}

#Preview {
    ChallengeView()
}
