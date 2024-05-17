//
//  HistoryView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

// TODO: 필터 구현 시 클릭된 필터 히스토리 뷰에 표출
// TODO: 데이터 필터링 구현
import SwiftUI

var dummy = [
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .comfortable, reactionValue: .good),
]

struct HistoryView: View {
    var body: some View {
        HistoryViewHandler(count: 0)
    }
}

@ViewBuilder
func HistoryViewHandler(count: Int) -> some View {
    if count == 0 {
        emptyHistoryView
    } else {
        hasDateHistoryView
    }
}

var hasDateHistoryView: some View {
    NavigationStack {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("챌린지 표현")
                    .font(.title)
                    .foregroundStyle(Theme.black)
                    .bold()
                
                Text("\(dummy.count)")
                    .foregroundStyle(Theme.point)
                    .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundStyle(Theme.point)
            }
            
            .padding([.leading, .top, .trailing], Theme.padding)
            .padding(.bottom, 28)
            
            ScrollView {
                ForEach(dummy, id: \.id) { dummy in
                    NavigationLink(destination: HistoryDetailView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: Theme.round)
                                .fill(Theme.white)
                                .frame(width: 353, height: 92)
                                .dropShadow(opacity: 0.15)
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Text(dummy.expression)
                                    .foregroundStyle(Theme.black)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        .padding([.leading, .trailing, .bottom], Theme.padding)
                    }
                }
            }
        }
        .background(Theme.background)
    }
}

var emptyHistoryView: some View {
    NavigationStack {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("챌린지 표현")
                    .font(.title)
                    .foregroundStyle(Theme.black)
                    .bold()
                
                Text("0")
                    .foregroundStyle(Theme.point)
                    .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundStyle(Theme.point)
            }
            
            .padding([.leading, .top, .trailing], Theme.padding)
            .padding(.bottom, 28)
            Spacer()
            VStack(spacing: 0) {
                Text("아직 기록이 없어요!")
                    .foregroundStyle(Theme.subblack)
            }
            Spacer()
        }
        .background(Theme.background)
    }
}

#Preview {
    HistoryView()
}
