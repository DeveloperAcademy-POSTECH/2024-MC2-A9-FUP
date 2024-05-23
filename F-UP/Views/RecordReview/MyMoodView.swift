//
//  MyMoodView.swift
//  F-UP
//
//  Created by namdghyun on 5/20/24.
//

import SwiftUI

struct MyMoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showModal: Bool
    
    @State private var sliderValue: Double = 0
    @State private var navigationToNextView: Bool = false
    
    @State var history: History
    
    let target: Target
    let specificTarget: String?
    
    private let emojis: [Image] = [Image("expressionT1"), Image("expressionT2"), Image("expressionT3"), Image("expressionT4"), Image("expressionT5") ]
    private let strings = ["많이 어색해요", "조금 어색해요", "그저 그래요", "익숙해요!", "정말 익숙해요!"]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("이 따듯함을 건낸\n 나의 기분은 어떠한가요?")
                        .font(.title2 .weight(.bold))
                        .padding(.top, 38)
                        .padding(.bottom, 31)
                        .multilineTextAlignment(.center)
                    emojis[Int(sliderValue / 25)]
                        .frame(width: 250, height: 250)
                        .animation(.spring, value: sliderValue)
                    Text(strings[Int(sliderValue / 25)])
                        .font(.title2 .weight(.bold))
                        .padding(.top, 29)
                        .padding(.bottom, 38)
                        .animation(.spring, value: sliderValue)
                }
                .frame(width: 353)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                .padding(.top, 27)
                
                CustomSlider(value: $sliderValue, in: 0...100, step: 25)
                    .frame(height: 38)
                    .padding(.top, 22)
                    .animation(.spring, value: sliderValue)
                HStack(spacing: 0) {
                    Text("어색해요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                    Spacer()
                    Text("익숙해요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                }
                .padding(.top, 8)
                .padding(.horizontal, 7)
                Spacer()
                
                Button {
                    if navigationToNextView {
                        navigationToNextView = false
                    } else {
                        navigationToNextView = true
                    }
                } label : {
                    RoundedRectangle(cornerRadius: Theme.round)
                        .fill(Theme.point)
                        .dropShadow(opacity: 0.2)
                        .frame(width: 353, height: 50)
                        .overlay {
                            Text("다음으로 넘어가기")
                                .font(.headline .weight(.bold))
                                .foregroundStyle(Theme.white)
                        }
                }
                .navigationDestination(isPresented: $navigationToNextView) {
                    switch Int(sliderValue / 25) {
                    case 0:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .veryUncomfortable)
                    case 1:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .uncomfortable)
                    case 2:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .neutral)
                    case 3:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .comfortable)
                    case 4:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .veryComfortable)
                    default:
                        ReactionView(showModal: $showModal, history: history, target: target, specificTarget: specificTarget, feelingValue: .veryUncomfortable)
                    }
                    
                }
                
                
            }
            .padding(.horizontal, Theme.padding)
            .navigationTitle("기록하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                            Text("뒤로")
                        }
                        .foregroundStyle(Theme.point)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("취소") {
                        showModal = false
                    }
                    .tint(Theme.point)
                }
            }
        }
        
    }
}


#Preview {
    MyMoodView(showModal: .constant(true), history: History(date: Date(), streak: 0, challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral), target: .lover, specificTarget: "")
        .environment(AVFoundationManager())
        .environment(SwiftDataManager())
        .environment(RefreshTrigger())
}
