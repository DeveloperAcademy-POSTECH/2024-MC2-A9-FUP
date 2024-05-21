//
//  CarouselView.swift
//  F-UP
//
//  Created by 박현수 on 5/17/24.
//

import SwiftUI

struct CarouselView: View {
    @Binding var currentChallengeStep: ChallengeStep
    @State var history: History
    @State private var showModal: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20){
                    ForEach(1..<3, id: \.self) { index in
                        CarouselCell(index: index, cellWidth: geometry.size.width)
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

extension CarouselView {
    @ViewBuilder
    func CarouselCell(index: Int, cellWidth: Double) -> some View {
        switch index {
        case 1:
            VStack(spacing: 0) {
                Text("STEP \(index)")
                    .padding(.top, 26)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                Text("오늘의 표현을 따라 말해보세요!")
                    .padding(.top, 8)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                Text(currentChallengeStep == .notStarted ? "🎤" : "🎉")
                    .font(.system(size: 130))
                    .padding(.top, 41)
                    .padding(.bottom, 50)
                if (currentChallengeStep == .notStarted) {
                    challengeButton(history: history, currentChallengeStep: $currentChallengeStep, index: index)
                }
                else {
                    Text("챌린지 완료!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.white)
                        .padding(.bottom, 44)
                }
            }
            .containerRelativeFrame(.horizontal)
            .scrollTargetBehavior(.viewAligned)
            .frame(width: cellWidth - 74)
            .background(Theme.point)
            .clipShape(
                RoundedRectangle(cornerRadius: Theme.round)
            )
            .dropShadow(opacity: 0.4)
            
            
        case 2:
            VStack(spacing: 0) {
                Text("STEP \(index)")
                    .padding(.top, 26)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                Text("오늘의 문장을 주변 사람들에게\n실제로 사용하고 반응을 기록해보세요!")
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                switch currentChallengeStep {
                case .notStarted:
                    Text("🔒")
                        .font(.system(size: 130))
                        .padding(.top, 23)
                        .padding(.bottom, 47)
                case .recordingCompleted:
                    Text("🥰")
                        .font(.system(size: 130))
                        .padding(.top, 23)
                        .padding(.bottom, 47)
                case .challengeCompleted:
                    Text("🥳")
                        .font(.system(size: 130))
                        .padding(.top, 23)
                        .padding(.bottom, 47)
                }
                
                if !(currentChallengeStep == .challengeCompleted) {
                    challengeButton(history: history, currentChallengeStep: $currentChallengeStep, index: index)
                }
                else {
                    Text("챌린지 완료!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.white)
                        .padding(.bottom, 44)
                }
                
            }
            .containerRelativeFrame(.horizontal)
            .scrollTargetBehavior(.viewAligned)
            .frame(width: cellWidth - 74)
            .background(currentChallengeStep == .notStarted ? Theme.subblack : Theme.point)
            .clipShape(
                RoundedRectangle(cornerRadius: Theme.round)
            )
            .dropShadow(opacity: 0.4)
        default:
            Text("Hi")
        }
    }
}

fileprivate struct challengeButton: View {
    @State private var showModal: Bool = false
    @State var history: History
    @Binding var currentChallengeStep: ChallengeStep
    var index: Int
    
    var body: some View {
        switch index {
        case 1:
            Button {
                showModal = true
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
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .sheet(isPresented: $showModal, onDismiss: {
                
            }) {
                RecordingView(showModal: $showModal, history: history).interactiveDismissDisabled()
            }
        case 2:
            Button {
                showModal = true
            } label: {
                Text("리뷰하러 가기")
                    .font(.headline)
                    .foregroundStyle(currentChallengeStep == .notStarted ? Theme.subblack : Theme.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(currentChallengeStep == .notStarted ? Theme.whiteWithOpacity : Theme.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Theme.round)
                    )
            }
            .disabled(currentChallengeStep == .notStarted)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .sheet(isPresented: $showModal) {
                TargetSelectView(showModal: $showModal).interactiveDismissDisabled()
            }
        default:
            Button {
                showModal = true
            } label: {
                Text("리뷰하러 가기")
                    .font(.headline)
                    .foregroundStyle(Theme.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Theme.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Theme.round)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    CarouselView(currentChallengeStep: .constant(.notStarted), history: History(date: Date(), challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral))
}
