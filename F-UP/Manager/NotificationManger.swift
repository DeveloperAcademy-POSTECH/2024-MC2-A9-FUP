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
    
    func setDailyNoti(expressionIndex: Binding<Int>) {
        print("setDailyNoti")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
        self.setNotiContent(expressionIndex: expressionIndex)
    }
    
    func setNotiContent(expressionIndex: Binding<Int>) {
        print("setNotiContent")
        let index = expressionIndex.wrappedValue

        let content = UNMutableNotificationContent()
        content.title = "오늘의 챌린지를 수행해보세요"
        content.body = "\"\(dummyExpression[index])\""
        content.sound = .default
        
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
