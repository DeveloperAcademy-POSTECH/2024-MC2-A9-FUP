//
//  HistoryDetailView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/17/24.
//

// TODO: SwiftData로 Data 대체
// TODO: 녹음 재생
// TODO: 그라데이션 넣기
import SwiftUI

struct HistoryDetailView: View {
    var dummy: History
    @Environment(\.dismiss) var dismiss
    @State private var sliderValue = 0.0
    
    var body: some View {
        ZStack {
            Theme.background
            
            VStack(spacing: 0) {
                RecoderPlay(dummy: dummy)
                
                VStack(alignment: .leading ,spacing: 0) {
                    Text("누구에게 이 따뜻함을 건냈나요?")
                        .font(.body .weight(.bold))
                    HStack {
                        ForEach(Target.allCases, id: \.self) { target in
                            TargetButton(target: target, history: dummy)
                        }
                    }
                    .padding(.vertical, Theme.padding)
                    
                    if dummy.specificTarget != nil {
                        Text("* 친구인 ")
                            .font(.caption)
                            .foregroundStyle(Theme.semiblack)
                        +
                        Text(dummy.specificTarget ?? "")
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
                    ProgressView(value: Double(dummy.feelingValue.rawValue), total: 4)
                        .progressViewStyle(CustomProgressViewStyle())
                        .dropShadow(opacity: 0.15)
                }
                VStack(spacing: 0) {
                    FeelingProgressTitle(headLine: "타인의 반응", minValueTitle: "별로에요", maxValueTitle: "좋아요")
                    ProgressView(value: Double(dummy.reactionValue.rawValue), total: 4)
                        .progressViewStyle(CustomProgressViewStyle())
                        .dropShadow(opacity: 0.15)
                }
                Spacer()
            }
        }
        .navigationTitle("챌린지 표현")
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
        }
    }
}

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
                    .font(.callout)
                    .bold()
                    .foregroundColor(target == history.target ? Theme.white : Theme.black.opacity(0.3))
            }
            .dropShadow(opacity: 0.15)
    }
}

private func RecoderPlay(dummy: History) -> some View {
    return RoundedRectangle(cornerRadius: Theme.round)
        .fill(Theme.white)
        .frame(width: 353, height: 140)
        .overlay {
            VStack(alignment: .leading, spacing: 0) {
                Text("23.05.13의 표현") // formatting해서 변경하기
                    .font(.footnote .weight(.bold))
                    .foregroundStyle(Theme.semiblack)
                    .padding(.bottom, 5)
                Text("\"\(dummy.expression)\"")
                    .font(.headline)
                    .foregroundStyle(Theme.black)
                    .padding(.bottom, 21)
                HStack(spacing: 0) {
                    Image("waves")
                        .resizable()
                        .frame(width: 241, height: 31)
                    Button {
                        // 녹음 실행 event
                    }label: {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Theme.point)
                    }
                    .padding(.leading, 39)
                }
            }
        }
        .dropShadow(opacity: 0.15)
        .padding(.horizontal, Theme.padding)
        .padding(.bottom, 40)
        .padding(.top, 35)
}

private func FeelingProgressTitle(headLine: String, minValueTitle: String, maxValueTitle: String) -> some View {
    return VStack(alignment: .leading, spacing: 0) {
        Text(headLine)
            .font(.headline)
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

private struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let emojis = ["😂", "😅", "😊", "😁", "🥰"]
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20.5)
                .fill(Theme.subblack)
                .frame(width: 353, height: 38)
            
            RoundedRectangle(cornerRadius: 20.5)
                .fill(Theme.point)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 353, height: 38)
            
            if let fractionCompleted = configuration.fractionCompleted {
                Text(emojis[min(Int(fractionCompleted * 4), 4)])
                    .font(Font.system(size: 34))
                    .offset(x: fractionCompleted == 0 ? 0 : CGFloat(fractionCompleted) * 353 - 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(dummy: History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.exmaple.com")!, target: .family, specificTarget: "도리" ,feelingValue: .comfortable, reactionValue: .good))
    }
}

