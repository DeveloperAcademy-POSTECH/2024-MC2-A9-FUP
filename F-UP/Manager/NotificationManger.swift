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
    
    func setDailyNoti(expressionIndex: Binding<Int>, currentChallengeStep: Binding<ChallengeStep>) {
        print("setDailyNoti")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
        self.setNotiContent(expressionIndex: expressionIndex, currentChallengeStep: currentChallengeStep)
    }
    
    func setNotiContent(expressionIndex: Binding<Int>, currentChallengeStep: Binding<ChallengeStep>) {
        print("setNotiContent")
       
        let index = expressionIndex.wrappedValue
        let step = currentChallengeStep.wrappedValue.rawValue
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
        dateComponents.hour = 13
        dateComponents.minute = 01
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
