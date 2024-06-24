//
//  ChallengeView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI
import SwiftData

struct ChallengeView: View {
    @State var challengeViewModel = ChallengeViewModel()

    
    var body: some View {
        ZStack(alignment: .top){
            Color(Theme.background).ignoresSafeArea()
            
            //Title
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Text("챌린지")
                        .font(.title)
                        .foregroundStyle(Theme.black)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    HStack(spacing: 3) {
                        Text("\(challengeViewModel.streak ?? 0)일째 도전 성공")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(challengeViewModel.streak == 0 ? Theme.subblack : Theme.point)
                        Image(systemName: "flame.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 11)
                            .foregroundStyle(challengeViewModel.streak == 0 ? Theme.subblack : Theme.point)
                    }.padding(.top, 3)
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.top, 11)
                
                
                VStack(spacing: 0) {
                    Text("오늘의 표현")
                        .font(.footnote .weight(.regular))
                        .foregroundColor(Theme.semiblack)
                        .padding(.bottom, 3)
                    Text("“\(challengeViewModel.dummyExpression[challengeViewModel.expressionIndex].forceCharWrapping)”")
                        .font(.title3 .weight(.bold))
                        .foregroundColor(Theme.black)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                .padding(.horizontal, 37)
                .padding(.bottom, 50)
                .padding(.top, 6)
                
                ProgressIndicatorView
                if challengeViewModel.todaysHistory != nil {
                    CarouselView.padding(.top, -20)
                }
                
                Spacer()
                
                
            }
        }
        .onAppear() {            
            challengeViewModel.updateExpressionIndex()
            challengeViewModel.checkAndAddHistory()
            challengeViewModel.setDailyNoti()
        }
        .onChange(of: challengeViewModel.currentDateString) {
            challengeViewModel.updateExpressionIndex()
            challengeViewModel.checkAndAddHistory()
            challengeViewModel.setDailyNoti()
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            challengeViewModel.getAndCompareDateString()
        }
    }
}

//MARK: - 챌린지뷰 뷰빌더 (캐러셀뷰 extension 별도 분리)
extension ChallengeView {
    @ViewBuilder
    private var ProgressIndicatorView: some View {
        switch challengeViewModel.currentChallengeStep {
            
        case .notStarted:
            HStack(spacing: 0){
                Text("1. 말하기")
                    .font(.caption2 .weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .frame(height: 21, alignment: .center)
                    .background(Theme.point)
                    .clipShape(RoundedRectangle(cornerRadius: 10.5))
                
                DottedDivider(step: challengeViewModel.currentChallengeStep)
                
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
            
        case .recordingCompleted:
            HStack(spacing: 0){
                Circle()
                    .fill(Theme.point)
                    .frame(width: 20,height: 20)
                    .opacity(0.6)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 10)
                            .foregroundColor(Theme.white)
                    }
                
                DottedDivider(step: challengeViewModel.currentChallengeStep)
                
                Text("2. 기록하기")
                    .font(.caption2 .weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .frame(height: 21, alignment: .center)
                    .background(Theme.point)
                    .clipShape(RoundedRectangle(cornerRadius: 10.5))
            }
            .padding(.bottom, 19)
            .padding(.horizontal, 50)
            
        case .challengeCompleted:
            Text("챌린지 완료")
                .font(.caption2 .weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .frame(height: 21, alignment: .center)
                .background(Theme.point)
                .clipShape(RoundedRectangle(cornerRadius: 10.5))
                .padding(.bottom, 19)
                .padding(.horizontal, 50)
        }
    }
}



#Preview {
    ChallengeView()
        .modelContainer(for: History.self, inMemory: true)
        .environment(AVFoundationManager())
        .environment(SwiftDataManager())
}
