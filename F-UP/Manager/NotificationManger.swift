//
//  NotificationManger.swift
//  F-UP
//
//  Created by LeeWanJae on 5/22/24.
//

import SwiftUI
import UserNotifications

class NotificationManger {
    static let shared = NotificationManger()
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
    
    func setNotiAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if success {
                print("Noti All Set")
            }
        }
    }
    
    func setDailyNoti(expressionIndex: Int, currentChallengeStep: ChallengeStep) {
        print("setDailyNoti")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
        self.setNotiContent(expressionIndex: expressionIndex, currentChallengeStep: currentChallengeStep)
    }
    
    func setNotiContent(expressionIndex: Int, currentChallengeStep: ChallengeStep) {
        print("setNotiContent")
       
        let index = expressionIndex
        let step = currentChallengeStep.rawValue
        print(step)
        let content = UNMutableNotificationContent()
        
        switch step {
        case 0 :
            content.title = "오늘의 챌린지를 수행해보세요"
            content.body = "\"\(dummyExpression[index])\""
            content.sound = .default
        case 1 :
            content.title = "오늘의 표현을 실제로 사용해보세요"
            content.body = "\"\(dummyExpression[index])\""
            content.sound = .default
        case 2 :
            content.title = "챌린지를 수행하셨군요?"
            content.body = "오늘의 표현을 다시 보러갈까요?"
            content.sound = .default
        default:
            return
        }
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
