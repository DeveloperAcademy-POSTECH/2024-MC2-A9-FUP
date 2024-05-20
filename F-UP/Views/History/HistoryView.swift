//
//  HistoryView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

// TODO: 필터 구현 시 클릭된 필터 히스토리 뷰에 표출
// TODO: SwiftData로 Data 대체
import SwiftUI

struct HistoryView: View {
    @State var isShowingModal = false
    @State private var settingsDetent = PresentationDetent.medium
    
    var body: some View {
        HistoryViewHandler(count: dummyData.count, isShowingModal: $isShowingModal)
            .sheet(isPresented: $isShowingModal, content: {
                HistoryFilterView(isShowingModal: $isShowingModal)
                    .presentationDetents(
                        [.medium],
                        selection: $settingsDetent
                    )
            })
    }
}

@ViewBuilder
private func HistoryViewHandler(count: Int, isShowingModal: Binding<Bool>) -> some View {
    if count == 0 {
        emptyHistoryView()
    } else {
        hasDateHistoryView(isShowingModal: isShowingModal)
    }
}

private func hasDateHistoryView(isShowingModal: Binding<Bool>) -> some View {
    return NavigationStack {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("챌린지 표현")
                    .font(.title)
                    .foregroundStyle(Theme.black)
                    .bold()
                Text("\(dummyData.count)")
                    .font(.footnote)
                    .foregroundStyle(Theme.point)
                    .padding(.leading, 8)
                    .padding(.top, 10)
                Spacer()
                Button {
                    isShowingModal.wrappedValue.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(Theme.point)
                }
            }
            .padding(.horizontal, Theme.padding)
            .padding(.bottom, 28)
            
            ScrollView {
                ForEach(dummyData, id: \.id) { dummy in
                    NavigationLink(destination: HistoryDetailView(dummy: dummy)) {
                        RoundedRectangle(cornerRadius: Theme.round)
                            .fill(Theme.white)
                            .frame(width: 353, height: 92)
                            .dropShadow(opacity: 0.15)
                            .overlay {
                                Text(dummy.expression)
                                    .font(.title3)
                                    .foregroundStyle(Theme.black)
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom, 10)
                            .padding(.horizontal, Theme.padding)
                    }
                }
            }
        }
        .background(Theme.background)
    }
}

private func emptyHistoryView() -> some View {
    return NavigationStack {
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

var dummyData: [History] = [
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "오늘 하루도 정말 수고 많았어", audioURL: URL(string: "www.example.com")!, target: .friend, specificTarget: "이안", feelingValue: .veryUncomfortable, reactionValue: .veryBad),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "고생했다 이안, 칭찬해", audioURL: URL(string: "www.example.com")!, target: .family, specificTarget: "진토", feelingValue: .uncomfortable, reactionValue: .bad),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "너도 오늘 하루 고생 많았어", audioURL: URL(string: "www.example.com")!, target: .acquaintance, specificTarget: "보노", feelingValue: .neutral, reactionValue: .neutral),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "나무디 밤새 개발하느라 고생하셨어요", audioURL: URL(string: "www.example.com")! ,target: .lover, feelingValue: .comfortable, reactionValue: .good),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "수박도 깃 알려주시느라 너무 고생하셨어요", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .veryComfortable, reactionValue: .veryGood),
    History(date: Date(), challengeStep: .ChallengeCompleted, expression: "디자인도 너무 고생 많으셨어요", audioURL: URL(string: "www.example.com")!, target: .friend, feelingValue: .veryUncomfortable, reactionValue: .veryBad),
]
