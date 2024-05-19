//
//  DottedDivider.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import Foundation
import SwiftUI

struct DottedDivider: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundStyle(Theme.point)
        }
        .frame(height: 1)
    }
}
