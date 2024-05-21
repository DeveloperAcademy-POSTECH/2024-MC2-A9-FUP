//
//  DottedDivider.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import Foundation
import SwiftUI

struct DottedDivider: View {
    let step: ChallengeStep
    
    var body: some View {
        let gradient = LinearGradient(
            gradient: Gradient(
                colors: [Theme.point.opacity(step == .notStarted ? 1 : 0.6), Theme.point, Theme.point.opacity(step == .notStarted ? 0.6 : 1)]
            ),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
            }
            .stroke(gradient, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        }
        .frame(height: 1)
    }
}
