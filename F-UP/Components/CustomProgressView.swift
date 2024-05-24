//
//  CustomProgressView.swift
//  F-UP
//
//  Created by namdghyun on 5/24/24.
//

import SwiftUI

struct CustomProgressView<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    // MARK: - 프로퍼티
    // MARK: Private
    private let value: Double
    
    private let bounds: ClosedRange<V>
    
    private let length: CGFloat    = 38
    private let lineWidth: CGFloat = 2
    
    // MARK: - 생성자
    init(value: Double, in bounds: ClosedRange<V>) {
        self.value  = value
        
        self.bounds = bounds
    }
    
    // MARK: - 뷰
    // MARK: Public
    var body: some View {
        let emojis: [Image] = [Image("expression1"), Image("expression2"), Image("expression3"), Image("expression4"), Image("expression5"), ]
        let ratio = min(1, max(0,CGFloat(value / Double(bounds.upperBound))))
        
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                // Track
                GradientView(firstColor: Color(red: 0.73, green: 0.75, blue: 0.8).opacity(0.7),
                             secondColor: Color(red: 0.73, green: 0.75, blue: 0.8).opacity(0.5),
                             isPresentFirst: true)
                
                GradientView(firstColor: Theme.point,
                             secondColor: Theme.point.opacity(0.6),
                             isPresentFirst: false)
                .mask(
                    GeometryReader { proxy in
                        Capsule()
                            .frame(width: ((proxy.size.width - length) * ratio + 2.5 + length))
                    }
                )
                
                // Thumb
                Circle()
                    .foregroundColor(.white)
                    .overlay {
                        emojis[Int(value)]
                    }
                    .frame(width: length * 0.8, height: length)
                    .dropShadow(opacity: 0.15)
                    .offset(x: (proxy.size.width - length) * ratio + 4.5)
            }
            .frame(height: 38)
        }
    }
    
    // MARK: - 트랙 (배경)
    private func GradientView(firstColor: Color, secondColor: Color, isPresentFirst: Bool) -> some View {
        return LinearGradient(
            stops: [
                Gradient.Stop(color: firstColor, location: 0.00),
                Gradient.Stop(color: secondColor, location: 1.00),
            ],
            startPoint: UnitPoint(x: 1, y: 1),
            endPoint: UnitPoint(x: 0, y: 0)
        )
        .background(.white)
        .clipShape(Capsule())
        .dropShadow(opacity: 0.15)
        .opacity(isPresentFirst
                 ? 1 - Double(value) / Double(bounds.upperBound)
                 : Double(value) / Double(bounds.upperBound)
        )
    }
}

#Preview {
    CustomProgressView(value: 3, in: 0...4)
        .frame(height: 38)
}
