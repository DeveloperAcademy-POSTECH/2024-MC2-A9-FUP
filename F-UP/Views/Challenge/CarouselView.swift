//
//  CarouselView.swift
//  F-UP
//
//  Created by 박현수 on 5/17/24.
//

import SwiftUI

// MARK: - 캐러셀뷰 + 서브뷰 뷰빌더
extension ChallengeView {
    
    @ViewBuilder
    var CarouselView: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -20){
                    ForEach(1..<3, id: \.self) { index in
                        CarouselCell(index: index, cellWidth: geometry.size.width)
                            .safeAreaPadding(.vertical, 20)
                    }.scrollTransition(.animated, axis: .horizontal) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.5)
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                    }
                }
            }.safeAreaPadding(.horizontal, 37)
        }
    }
    
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
                
                Text(challengeViewModel.currentChallengeStep == .notStarted ? "오늘의 표현을 따라 말해보세요!" : "따라 말하기")
                    .padding(.top, challengeViewModel.currentChallengeStep == .notStarted ? 8 : 4)
                    .padding(.bottom, challengeViewModel.currentChallengeStep == .notStarted ? 7 : 8)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                Image(challengeViewModel.currentChallengeStep == .notStarted ? "characterChallenge1" : "characterCelebrate1")
                    .frame(
                        width: challengeViewModel.currentChallengeStep == .notStarted ? 200 : 250,
                        height: challengeViewModel.currentChallengeStep == .notStarted ? 200 : 236
                    )
                    .padding(.bottom, challengeViewModel.currentChallengeStep == .notStarted ? 15 : 2)
                if challengeViewModel.todaysHistory != nil && (challengeViewModel.currentChallengeStep == .notStarted) {
                    ChallengeButton(index: index)
                }
                else {
                    Text("챌린지 완료!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.white)
                        .padding(.bottom, 24)
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
                
                Text(challengeViewModel.currentChallengeStep == .challengeCompleted ? "사용하고 기록하기" : "오늘의 표현을 주변 사람들에게\n실제로 사용하고 반응을 기록해보세요!")
                    .padding(.top, challengeViewModel.currentChallengeStep == .challengeCompleted ? 4 : 8)
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.white)
                
                switch challengeViewModel.currentChallengeStep {
                case .notStarted:
                    Image("lock")
                        .frame(width: 200, height: 174)
                        .padding(.top, 12)
                        .padding(.bottom, 15)
                case .recordingCompleted:
                    Image("characterChallenge2")
                        .frame(width: 200, height: 179)
                        .padding(.top, 7)
                        .padding(.bottom, 15)
                case .challengeCompleted:
                    Image("characterCelebrate2")
                        .frame(width: 250, height: 236)
                        .padding(.top, 8)
                        .padding(.bottom, 2)
                }
                
                if challengeViewModel.todaysHistory != nil && !(challengeViewModel.currentChallengeStep == .challengeCompleted) {
                    ChallengeButton(index: index)
                }
                else {
                    Text("챌린지 완료!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.white)
                        .padding(.bottom, 24)
                }
                
            }
            .containerRelativeFrame(.horizontal)
            .scrollTargetBehavior(.viewAligned)
            .frame(width: cellWidth - 74)
            .background(challengeViewModel.currentChallengeStep == .notStarted ? Theme.subblack : Theme.point)
            .clipShape(
                RoundedRectangle(cornerRadius: Theme.round)
            )
            .dropShadow(opacity: 0.4)
        default:
            Text("Hi")
        }
    }
    
    @ViewBuilder
    func ChallengeButton(index: Int) -> some View {
        switch index {
        case 1:
            Button {
                challengeViewModel.showModal = true
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
            .padding(.horizontal, 19)
            .padding(.bottom, 19)
            .sheet(isPresented: $challengeViewModel.showModal, onDismiss: {
                withAnimation {
                    challengeViewModel.updateExpressionIndex()
                    challengeViewModel.checkAndAddHistory()
                    challengeViewModel.setDailyNoti(expressionIndex: $challengeViewModel.expressionIndex, currentChallengeStep: $challengeViewModel.currentChallengeStep)
                }
            }) {
                if challengeViewModel.todaysHistory != nil {
                    RecordingView(showModal: $challengeViewModel.showModal, history: challengeViewModel.todaysHistory!).interactiveDismissDisabled()
                }
            }
            .onChange(of: challengeViewModel.showModal) { _, _ in
                HapticManager.shared.generateHaptic(.light(times: 1))
            }
            
        case 2:
            Button {
                challengeViewModel.showModal = true
            } label: {
                Text("리뷰하러 가기")
                    .font(.headline)
                    .foregroundStyle(challengeViewModel.currentChallengeStep == .notStarted ? Theme.subblack : Theme.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(challengeViewModel.currentChallengeStep == .notStarted ? Theme.whiteWithOpacity : Theme.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Theme.round)
                    )
            }
            .disabled(challengeViewModel.currentChallengeStep == .notStarted)
            .padding(.horizontal, 19)
            .padding(.bottom, 19)
            .sheet(isPresented: $challengeViewModel.showModal, onDismiss: {
                withAnimation {
                    challengeViewModel.updateExpressionIndex()
                    challengeViewModel.checkAndAddHistory()
                    challengeViewModel.setDailyNoti(expressionIndex: $challengeViewModel.expressionIndex, currentChallengeStep: $challengeViewModel.currentChallengeStep)
                }
            }) {
                if challengeViewModel.todaysHistory != nil {
                    TargetSelectView(showModal: $challengeViewModel.showModal, history: challengeViewModel.todaysHistory!).interactiveDismissDisabled()
                }
            }
            .onChange(of: challengeViewModel.showModal) { _, _ in
                HapticManager.shared.generateHaptic(.light(times: 1))
            }
            
        default:
            Button {
                challengeViewModel.showModal = true
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
            .frame(width: 281, height: 50)
            .padding(.horizontal, 19)
            .padding(.bottom, 19)
            .onChange(of: challengeViewModel.showModal) { _, _ in
                HapticManager.shared.generateHaptic(.light(times: 1))
            }
        }
    }
}
