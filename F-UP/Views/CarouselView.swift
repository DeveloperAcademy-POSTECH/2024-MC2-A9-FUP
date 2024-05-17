//
//  CarouselView.swift
//  F-UP
//
//  Created by 박현수 on 5/17/24.
//

import SwiftUI

struct CarouselView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    ForEach(1..<3, id: \.self) { index in
                        VStack(spacing: 0) {
                            Text("STEP \(index)")
                                .padding(.top, 26)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text("\(geometry.size.width)")
                        }
                        .containerRelativeFrame(.horizontal)
                        .scrollTargetBehavior(.viewAligned)
                        .frame(width: geometry.size.width - 74)
//                        .safeAreaPadding(.horizontal, 40.0)
                            .background(Color(uiColor: UIColor(red: 0.18, green: 0.73, blue: 0.7, alpha: 1)))
                    }
                }
            }
        }
    }
}

#Preview {
    CarouselView()
}
