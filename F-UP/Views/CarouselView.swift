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
                HStack(spacing: -20){
                    ForEach(1..<3, id: \.self) { index in
                        VStack(spacing: 0) {
                            Text("STEP \(index)")
                                .padding(.top, 26)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.white)
                            
                            Text("오늘의 표현을 따라 말해보세요!")
                                .padding(.top, 8)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.white)
                            
                            Text("🎤")
                                .font(.system(size: 130))
                                .padding(.top, 41)
                                .padding(.bottom, 50)
                            
                            Button {
                                //
                            } label: {
                                Text("따라 말하기")
                                    .font(.headline)
                                    .foregroundStyle(Theme.black)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 14)
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.white)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: Theme.round)
                                    )
                            }.padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }
                        .containerRelativeFrame(.horizontal)
                        .scrollTargetBehavior(.viewAligned)
                        .frame(width: geometry.size.width - 74)
                        .background(Theme.point)
                        .clipShape(
                            RoundedRectangle(cornerRadius: Theme.round)
                        )
                    }.scrollTransition(.animated, axis: .horizontal) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.5)
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                    }

                }
            }.safeAreaPadding(.horizontal, 37) 
        }
    }
}

#Preview {
    CarouselView()
}
