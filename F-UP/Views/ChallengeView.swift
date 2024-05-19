//
//  ChallengeView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI

struct ChallengeView: View {
    var body: some View {
        ZStack(alignment: .top){
            Color(Theme.background).ignoresSafeArea()
            
            //Title
            VStack(spacing: 0) {
                HStack {
                    Text("챌린지")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    
                    //streak
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.footnote .weight(.semibold))
                                .foregroundColor(Theme.point)
                            Text("10") //streak 변수
                                .font(.footnote .weight(.semibold))
                                .foregroundColor(Theme.point)
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Theme.background)
                    .cornerRadius(12.5)
                    .overlay(
                      RoundedRectangle(cornerRadius: 12.5)
                        .inset(by: 0.65)
                        .stroke(Theme.point, lineWidth: 1.3)
                    )
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.top, 11)
                
            //오늘의 표현
//            ZStack {
                VStack(spacing: 0) {
                    Text("오늘의 표현")
                        .font(.footnote .weight(.regular))
                        .foregroundColor(Theme.semiblack)
                        .padding(.bottom, 3)
                    Text("“오늘 하루도 정말 수고 많았어.”")
                        .font(.title3 .weight(.bold))
                        .foregroundColor(Theme.black)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 22)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                //.cornerRadius(Theme.round)
                .padding(.bottom, 50)
//            }
                
                
            //progress bar (애니메이션으로 제작 가능성 있음)
                VStack(spacing: 0) {
                    HStack(spacing: 0){
                        Text("1. 말하기")
                            .font(.caption2 .weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.white)
//                            .foregroundColor(Theme.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .frame(height: 21, alignment: .center)
                            .background(Theme.point)
                            .clipShape(RoundedRectangle(cornerRadius: 10.5))
//                            .cornerRadius(10.5)
                        
//                        Image("Vector 10")
                        DottedDivider()
                        // SVG 이미지 -> divider로 제작 가능한지 확인 필요
                        
                        Circle()
                            .fill(Theme.point)
                            .frame(width: 20,height: 20)
                            .opacity(0.6)
                            .overlay {
                                Text("2")
                                    .font(.caption2 .weight(.bold))
                                    .foregroundColor(Theme.white)
                            }
                        
                    }
                    .padding(.bottom, 19)
                    .padding(.horizontal, 50)
                    
                    
                    CarouselView()
                    
                    Spacer()
            //캐러셀 공간
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: 319, height: 380)
//                        .background(Theme.point)
//                        .cornerRadius(Theme.round)
//                        .shadow(color: Color(red: 0.55, green: 0.56, blue: 0.61).opacity(0.3), radius: 5, x: 0, y: 1)
                }
            }
        }
    }
}
//        ZStack {
//            Theme.background.ignoresSafeArea()
//            
//            VStack {
//                RoundedRectangle(cornerRadius: Theme.round)
//                    .fill(Theme.point)
//                    .frame(height: 200)
//                    .padding(Theme.padding)
//                    .dropShadow(opacity: 0.5)
//            }
//            
//        }
//    }
//}

#Preview {
    ChallengeView()
}
