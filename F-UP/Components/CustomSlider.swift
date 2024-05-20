//
//  CustomSlider.swift
//  F-UP
//
//  Created by namdghyun on 5/20/24.
//

import SwiftUI

struct CustomSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    // MARK: - 프로퍼티
    // MARK: Private
    @Binding private var value: V
    private let bounds: ClosedRange<V>
    private let step: V.Stride
    
    private let length: CGFloat    = 38
    private let lineWidth: CGFloat = 2
    
    @State private var ratio: CGFloat   = 0
    @State private var startX: CGFloat? = nil
    
    // MARK: - 생성자
    init(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1) {
        _value  = value
        
        self.bounds = bounds
        self.step   = step
    }
    
    // MARK: - 뷰
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                // Track
                gradientView(firstColor: Color(red: 0.73, green: 0.75, blue: 0.8).opacity(0.7),
                             secondColor: Color(red: 0.73, green: 0.75, blue: 0.8).opacity(0.5),
                             isPresentFirst: true)
                
                gradientView(firstColor: Theme.point,
                             secondColor: Theme.point.opacity(0.6),
                             isPresentFirst: false)
                
                // Thumb
                Circle()
                    .foregroundColor(.white)
                    .frame(width: length * 0.8, height: length)
                    .dropShadow(opacity: 0.15)
                    .offset(x: (proxy.size.width - length) * ratio + 4.5)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ updateStatus(value: $0, proxy: proxy) })
                        .onEnded { _ in startX = nil })
            }
            .frame(height: 38)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged({ update(value: $0, proxy: proxy) }))
            .onAppear {
                ratio = min(1, max(0,CGFloat(value / bounds.upperBound)))
            }
        }
    }
    
    // MARK: - 트랙 (배경)
    private func gradientView(firstColor: Color, secondColor: Color, isPresentFirst: Bool) -> some View {
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
    
    // MARK: - 메소드
    // MARK: Private
    private func updateStatus(value: DragGesture.Value, proxy: GeometryProxy) {
        guard startX == nil else { return }
        
        let delta = value.startLocation.x - (proxy.size.width - length) * ratio
        startX = (length < value.startLocation.x && 0 < delta) ? delta : value.startLocation.x
    }
    
    private func update(value: DragGesture.Value, proxy: GeometryProxy) {
        guard let x = startX else { return }
        startX = min(length, max(0, x))
        
        var point = value.location.x - x
        let delta = proxy.size.width - length
        
        // Check the boundary
        if point < 0 {
            startX = value.location.x
            point = 0
            
        } else if delta < point {
            startX = value.location.x - delta
            point = delta
        }
        
        // Ratio
        var ratio = point / delta
        
        
        // Step
        if step != 1 {
            let unit = CGFloat(step) / CGFloat(bounds.upperBound)
            
            let remainder = ratio.remainder(dividingBy: unit)
            if remainder != 0 {
                ratio = ratio - CGFloat(remainder)
            }
        }
        
        self.ratio = ratio
        self.value = V(bounds.upperBound) * V(ratio)
    }
}

#Preview {
    CustomSlider(value: .constant(0.5), in: 1...100)
        .frame(width: 300, height: 100)
}
