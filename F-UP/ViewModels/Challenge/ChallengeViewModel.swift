//
//  ChallengeViewModel.swift
//  F-UP
//
//  Created by 박현수 on 5/27/24.
//
import Foundation
import SwiftData
import SwiftUI

@Observable
final class ChallengeViewModel {
    let modelContext: ModelContext
    
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
    
    init() {
        modelContext = ModelContext(SwiftDataManager.shared.container)
    }
    
    var histories: [History] = []
    var todaysHistory: History? = nil
    var yesterdaysHistory: History? = nil
    var currentDateString: String = Date().formatted(date: .abbreviated, time: .omitted)
    var expressionIndex: Int = 0
    var currentChallengeStep: ChallengeStep = .notStarted
    var showModal: Bool = false
    var streak = UserDefaults(suiteName: "group.f_up.group.com")?.integer(forKey: "streak")
//    @AppStorage("streak", store: UserDefaults(suiteName: "group.f_up.group.com")) var streak: Int = 0
    
    
    func fetchHistories() {
        do {
            try histories = SwiftDataManager.shared.fetchHistories(modelContext: modelContext)
        }
        catch {
            fatalError("fetch error \(error.localizedDescription)")
        }
    }
    
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
    }
    
    func updateHistories() {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        fetchHistories()
        let todayHistories = histories.filter {
            $0.date.formatted(date: .abbreviated, time: .omitted)
            ==
            Date().formatted(date: .abbreviated, time: .omitted)
        }
        let yesterdayHistories = histories.filter {
            $0.date.formatted(date: .abbreviated, time: .omitted)
            ==
            yesterday.formatted(date: .abbreviated, time: .omitted)
        }
        if !todayHistories.isEmpty {
            todaysHistory = todayHistories[0]
            currentChallengeStep = todaysHistory?.challengeStep ?? .notStarted
        }
        if !yesterdayHistories.isEmpty {
            yesterdaysHistory = yesterdayHistories[0]
        }
    }
    
    func setUpStreak() {
        if yesterdaysHistory != nil && yesterdaysHistory!.isPerformed {
            if let todaysHistory = todaysHistory, let yesterdaysHistory = yesterdaysHistory {
                streak = todaysHistory.isPerformed ?
                todaysHistory.streak :
                yesterdaysHistory.streak
            }
        }
        else {
            if let todaysHistory = todaysHistory {
                streak = todaysHistory.streak
            }
        }
    }
    
    func checkAndAddHistory() {
        updateHistories()
        if todaysHistory == nil {
            SwiftDataManager.shared.addHistory(modelContext: modelContext, expression: dummyExpression[expressionIndex])
        }
        updateHistories()
        setUpStreak()
    }
    
    func setDailyNoti(expressionIndex: Binding<Int>, currentChallengeStep: Binding<ChallengeStep>) {
        NotificationManger.shared.setDailyNoti(expressionIndex: expressionIndex, currentChallengeStep: currentChallengeStep)
    }
    
    func getAndCompareDateString() {
        let newDateString = Date().formatted(date: .abbreviated, time: .omitted)
        
        if newDateString != currentDateString {
            if currentChallengeStep != .recordingCompleted {
                currentDateString = newDateString
            }
        }
    }
}
