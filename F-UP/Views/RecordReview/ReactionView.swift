//
//  ReactionView.swift
//  F-UP
//
//  Created by namdghyun on 5/20/24.
//

import SwiftUI

struct ReactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(SwiftDataManager.self) var swiftDataManager
    @Environment(RefreshTrigger.self) var refreshTrigger
    @Binding var showModal: Bool
    
    @State private var sliderValue: Double = 0
    
    @State var history: History
    
    let target: Target
    let specificTarget: String?
    let feelingValue: FeelingValue
    
    private let emojis = ["😂", "😅", "😊", "😁", "🥰"]
    private let strings = ["많이 별로에요", "별로에요", "보통이에요", "좋아요", "너무 좋아요"]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("상대방의 반응은 어땠나요?")
                        .font(.title2 .weight(.bold))
                        .padding(.top, 38)
                    Text(emojis[Int(sliderValue / 25)]).font(.system(size: 220))
                        .padding(.top, 43)
                        .animation(.spring, value: sliderValue)
                    Text(strings[Int(sliderValue / 25)])
                        .font(.title2 .weight(.bold))
                        .padding(.top, 47)
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
                    Text("별로에요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                    Spacer()
                    Text("좋아요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                }
                .padding(.top, 8)
                .padding(.horizontal, 7)
                Spacer()
                
                Button {
                    switch Int(sliderValue / 25) {
                    case 0:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .veryBad)
                    case 1:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .bad)
                    case 2:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .neutral)
                    case 3:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .good)
                    case 4:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .veryGood)
                    default:
                        swiftDataManager.updateHistoryAfterChallenge(modelContext: modelContext, history: history, target: target, specificTarget: specificTarget, feelingValue: feelingValue, reactionValue: .veryBad)
                    }
                    refreshTrigger.trigger.toggle()
                    showModal = false
                } label : {
                    RoundedRectangle(cornerRadius: Theme.round)
                        .fill(Theme.point)
                        .dropShadow(opacity: 0.2)
                        .frame(width: 353, height: 50)
                        .overlay {
                            Text("챌린지 모두 완료하기")
                                .font(.headline .weight(.bold))
                                .foregroundStyle(Theme.white)
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
                        dismiss()
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
    ReactionView(showModal: .constant(true), history: History(date: Date(), challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral), target: .acquaintance, specificTarget: "", feelingValue: .comfortable)
        .environment(AVFoundationManager())
        .environment(SwiftDataManager())
        .environment(RefreshTrigger())
}
