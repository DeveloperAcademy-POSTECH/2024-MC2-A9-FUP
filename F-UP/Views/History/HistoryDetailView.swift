//
//  HistoryDetailView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/17/24.
//

// TODO: 녹음 재생
import SwiftUI

struct HistoryDetailView: View {
    @Environment(AVFoundationManager.self) var avFoundationManager
    @Environment(\.dismiss) var dismiss
    @State var formattedDate: String = ""
    var history: History
    
    var body: some View {
        ZStack {
            Theme.background
            
            VStack(spacing: 0) {
                RecoderPlay(manager: avFoundationManager)
                
                VStack(alignment: .leading ,spacing: 0) {
                    Text("누구에게 이 따뜻함을 건냈나요?")
                        .font(.headline .weight(.bold))
                    HStack {
                        ForEach(Target.allCases, id: \.self) { target in
                            TargetButton(target: target, history: history)
                        }
                    }
                    .padding(.vertical, Theme.padding)
                    
                    if history.specificTarget != nil {
                        Text("* \(history.target.rawValue)인 ")
                            .font(.caption)
                            .foregroundStyle(Theme.semiblack)
                        +
                        Text(history.specificTarget ?? "")
                            .font(.caption .weight(.bold))
                            .foregroundStyle(Theme.semiblack)
                        +
                        Text("에게 건냈어요!")
                            .font(.caption)
                            .foregroundStyle(Theme.semiblack)
                    }
                }
                .padding(.horizontal, Theme.padding)
                
                VStack(spacing: 0) {
                    FeelingProgressTitle(headLine: "내 기분", minValueTitle: "어색해요", maxValueTitle: "익숙해요")
                    CustomProgressView(value: Double(history.feelingValue.rawValue), in: 0...4)
                        .frame(width: 353, height: 38)
                }
                VStack(spacing: 0) {
                    FeelingProgressTitle(headLine: "타인의 반응", minValueTitle: "별로에요", maxValueTitle: "좋아요")
                    CustomProgressView(value: Double(history.reactionValue.rawValue), in: 0...4)
                        .frame(width: 353, height: 38)
                }
                Spacer()
            }
        }
        .onAppear {
            dateFormatted()
        }
        .navigationTitle("챌린지 표현")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    HapticManager.shared.generateHaptic(.light(times: 1))
                    avFoundationManager.stopPlaying()
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
        }
    }
}

extension HistoryDetailView {
    private struct TargetButton: View {
        var target:Target
        var history: History
        @State private var borderColor = Theme.subblack
        
        var body: some View {
            RoundedRectangle(cornerRadius: 26)
                .fill(target == history.target ? Theme.point : Theme.subblack .opacity(0.3))
                .frame(width: 80, height: 45)
                .overlay {
                    Text("\(target.rawValue)")
                        .font(.callout .weight(.bold))
                        .foregroundColor(target == history.target ? Theme.white : Theme.black.opacity(0.3))
                }
                .dropShadow(opacity: 0.15)
        }
    }
    
    private func RecoderPlay(manager: AVFoundationManager) -> some View {
        return VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: Theme.round)
                .fill(Theme.white)
                .frame(width: 353, height: 140)
                .dropShadow(opacity: 0.15)
                .overlay {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(formattedDate)의 표현")
                            .font(.footnote .weight(.bold))
                            .foregroundStyle(Theme.semiblack)
                            .padding(.bottom, 5)
                        Text("\"\(history.expression)\"")
                            .font(.headline .weight(.bold))
                            .foregroundStyle(Theme.black)
                            .padding(.bottom, 21)
                        HStack(spacing: 0) {
                            AudioPlayingComponent(audioLevels: history.audioLevels, audioLength: history.audioLength, maxHeight: 50)
                            Button {
                                HapticManager.shared.generateHaptic(.light(times: 1))
                                // 녹음 실행 event
                                if manager.isPlaying {
                                    manager.stopPlaying()
                                } else {
                                    manager.playRecorded(audioFilename: history.audioURL)
                                }
                            }label: {
                                Image(systemName: manager.isPlaying ? "square.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Theme.point)
                            }
                            .padding(.leading, 39)
                        }
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.bottom, 40)
                .padding(.top, 35)
        }
    }
    
    private func FeelingProgressTitle(headLine: String, minValueTitle: String, maxValueTitle: String) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text(headLine)
                .font(.headline .weight(.bold))
                .padding(.leading, Theme.padding)
            HStack(spacing: 0) {
                Text(minValueTitle)
                    .font(.footnote)
                    .foregroundStyle(Theme.semiblack)
                    .padding(.leading, 27)
                    .padding(.top, 12)
                    .bold()
                Spacer()
                Text(maxValueTitle)
                    .font(.footnote)
                    .foregroundStyle(Theme.semiblack)
                    .padding(.trailing, 27)
                    .padding(.top, 12)
                    .bold()
            }
        }
        .padding(.bottom, 8)
        .padding(.top, 40)
    }
    
    private func dateFormatted() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        formattedDate = dateFormatter.string(from: history.date)
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(history: History(date: Date(), streak: 0, challengeStep: .challengeCompleted, expression: "나무디 화이팅이에요!", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .comfortable, reactionValue: .bad))
            .environment(AVFoundationManager())
            .environment(SwiftDataManager())
            .environment(RefreshTrigger())
    }
}

