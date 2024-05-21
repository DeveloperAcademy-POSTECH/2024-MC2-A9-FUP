//
//  HistoryDetailView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/17/24.
//

// TODO: SwiftData로 Data 대체
// TODO: 녹음 재생
import SwiftUI

struct HistoryDetailView: View {
    var history: History
    @State private var formattedDate: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var sliderValue = 0.0
    
    var body: some View {
        ZStack {
            Theme.background
            
            VStack(spacing: 0) {
                RecoderPlay(history: history, formattedDate: formattedDate)
                
                VStack(alignment: .leading ,spacing: 0) {
                    Text("누구에게 이 따뜻함을 건냈나요?")
                        .font(.body .weight(.bold))
                    HStack {
                        ForEach(Target.allCases, id: \.self) { target in
                            TargetButton(target: target, history: history)
                        }
                    }
                    .padding(.vertical, Theme.padding)
                    
                    if history.specificTarget != nil {
                        Text("* 친구인 ")
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
                    ProgressView(value: Double(history.feelingValue.rawValue), total: 4)
                        .progressViewStyle(CustomProgressViewStyle())
                        .dropShadow(opacity: 0.15)
                }
                VStack(spacing: 0) {
                    FeelingProgressTitle(headLine: "타인의 반응", minValueTitle: "별로에요", maxValueTitle: "좋아요")
                    ProgressView(value: Double(history.reactionValue.rawValue), total: 4)
                        .progressViewStyle(CustomProgressViewStyle())
                        .dropShadow(opacity: 0.15)
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

private func RecoderPlay(history: History, formattedDate: String) -> some View {
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
                        .font(.headline)
                        .foregroundStyle(Theme.black)
                        .padding(.bottom, 21)
                    HStack(spacing: 0) {
                        Image("TempWaveImage")
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
            .padding(.horizontal, Theme.padding)
            .padding(.bottom, 40)
            .padding(.top, 35)
    }
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
        
        let progress = CGFloat(configuration.fractionCompleted ?? 0)
        
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20.5)
                .fill(LinearGradient(gradient: Gradient(colors: [Theme.subblack.opacity(0.5), Theme.subblack]), startPoint: .leading, endPoint: .trailing))
                .opacity(0.6)
                .frame(width: 353, height: 38)
                .overlay(
                    RoundedRectangle(cornerRadius: 20.5)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x94D9D7), Color(hex: 0x58C8C2)]), startPoint: .leading, endPoint: .trailing))
                        .opacity(0.8)
                        .frame(width: progress * 353, height: 38),
                    alignment: .leading
                )
                .overlay(
                    Text(emojis[Int(progress * 4)])
                        .font(Font.system(size: 34))
                        .offset(x: progress == 0 ? 0 : progress * 353 - 40),
                    alignment: .leading
                )
        }
    }
}

extension HistoryDetailView {
    private func dateFormatted() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        formattedDate = dateFormatter.string(from: history.date)
        }
    }

#Preview {
    NavigationStack {
        HistoryDetailView(history: History(date: Date(), challengeStep: .challengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.exmaple.com")!, target: .family, specificTarget: "도리" ,feelingValue: .veryUncomfortable, reactionValue: .veryGood))
    }
}

