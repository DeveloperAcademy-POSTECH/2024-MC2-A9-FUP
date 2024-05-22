//
//  ChallengeView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI
import SwiftData

let dummyExpression = [
    "생각나서 연락했어.",
    "보람찬 하루 보내",
    "항상 널 생각하고 있어",
    "알찬 하루 보내",
    "오늘 하루도 화이팅!",
    "행복한 하루 보내!",
    "즐거운 하루 보내",
    "오늘 뭐 먹었어?",
    "에구 많이 힘들었겠다",
    "너는 최고야"
]

struct ChallengeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SwiftDataManager.self) private var swiftDataManager
    @Environment(AVFoundationManager.self) private var avFoundationManager
    @Environment(RefreshTrigger.self) var refreshTrigger
    
    @Query private var histories: [History]

    @State var todayHistories: [History] = []
    @State var yesterdayHistories: [History] = []
    @State private var currentDateString: String = Date().formatted(date: .abbreviated, time: .omitted)
    @State private var expressionIndex: Int = 0
    @State var currentChallengeStep: ChallengeStep = .notStarted
    
    @AppStorage("streak") var streak: Int = 0
    
    var body: some View {
        ZStack(alignment: .top){
            Color(Theme.background).ignoresSafeArea()
            
            //Title
            VStack(spacing: 0) {
                HStack {
                    Text("챌린지")
                        .font(.title)
                        .foregroundStyle(Theme.black)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    //streak
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.footnote .weight(.semibold))
                                .foregroundColor(Theme.point)
                            Text("\(streak)") //streak 변수
                                .font(.footnote .weight(.semibold))
                                .foregroundColor(Theme.point)
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Theme.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.5)
                            .inset(by: 0.65)
                            .stroke(Theme.point, lineWidth: 1.3)
                    )
                    
                    Spacer()
                    #if DEBUG
                    if currentChallengeStep == .recordingCompleted || currentChallengeStep == .challengeCompleted {
                        Button(avFoundationManager.isPlaying ? "정지" : "재생") {
                            if avFoundationManager.isPlaying {
                                avFoundationManager.stopPlaying()
                            } else {
                                avFoundationManager.playRecorded(audioFilename: todayHistories[0].audioURL)
                            }
                        }.buttonStyle(.borderedProminent)
                    }
                    Button("초기화") {
                        swiftDataManager.deleteHistory(modelContext: modelContext, history: todayHistories[0])
                    }.buttonStyle(.borderedProminent).padding(.trailing, Theme.padding)
                    #endif
                }
                .padding(.bottom, 20)
                .padding(.top, 11)
                

                VStack(spacing: 0) {
                    Text("오늘의 표현")
                        .font(.footnote .weight(.regular))
                        .foregroundColor(Theme.semiblack)
                        .padding(.bottom, 3)
                    Text("“\(dummyExpression[expressionIndex])”")
                        .font(.title3 .weight(.bold))
                        .foregroundColor(Theme.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                .padding(.horizontal, 37)
                .padding(.bottom, 50)
                
                ProgressIndicatorView
                
                if !todayHistories.isEmpty {
                    CarouselView(
                        currentChallengeStep: $currentChallengeStep,
                        history: todayHistories[0]
                    )
                }
                
                Spacer()

                
            }
        }
        .onAppear() {
            updateExpressionIndex()
            checkAndAddHistory()
        }
        .onChange(of: refreshTrigger.trigger) {
            updateExpressionIndex()
            checkAndAddHistory()
        }
        .onChange(of: currentDateString) {
            updateExpressionIndex()
            checkAndAddHistory()
            print(histories)
            print(todayHistories)
            print(yesterdayHistories)
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            let newDateString = Date().formatted(date: .abbreviated, time: .omitted)
            
            if newDateString != currentDateString {
                print("날짜바뀜")

                if currentChallengeStep != .recordingCompleted {
                    currentDateString = newDateString
                }
            }
        }
    }
}




// 데이터 관련 메소드
extension ChallengeView {
    
    func updateExpressionIndex() {
        let calendar = Calendar.current
        
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 1
        dateComponents.day = 1

        guard let specificDate = calendar.date(from: dateComponents) else {
            print("날짜를 생성할 수 없습니다.")
            return
        }

        let components = calendar.dateComponents([.day], from: specificDate, to: currentDate)

        guard let daysElapsed = components.day else {
            print("일수를 계산할 수 없습니다.")
            return
        }
        
        expressionIndex = daysElapsed % dummyExpression.count
        print("expressionIndex: \(expressionIndex)")
        NotificationManger.shared.setDailyNoti(expressionIndex: $expressionIndex)
    }
    
    func updateHistories() {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
                
        todayHistories = histories.filter {
            $0.date.formatted(date: .abbreviated, time: .omitted)
            ==
            Date().formatted(date: .abbreviated, time: .omitted)
        }
        yesterdayHistories = histories.filter {
            $0.date.formatted(date: .abbreviated, time: .omitted)
            ==
            yesterday.formatted(date: .abbreviated, time: .omitted)
        }
        if !todayHistories.isEmpty {
            currentChallengeStep = todayHistories[0].challengeStep
        }
    }
    
    func setUpStreak() {
        if !yesterdayHistories.isEmpty {
            if yesterdayHistories[0].isPerformed {
                streak += 1
            }
            else {
                streak = 0
            }
        }
        else {
            streak = 0
        }
    }
    
    func checkAndAddHistory() {
        updateHistories()
        if todayHistories.isEmpty {
            swiftDataManager.addHistory(modelContext: modelContext, expression: dummyExpression[expressionIndex])
        }
        updateHistories()
        setUpStreak()
    }
}



// 뷰빌더
extension ChallengeView {
    @ViewBuilder
    private var ProgressIndicatorView: some View {
        switch currentChallengeStep {
            
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

                DottedDivider(step: currentChallengeStep)
                
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
                
                DottedDivider(step: currentChallengeStep)
                
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
        .environment(RefreshTrigger())
}
