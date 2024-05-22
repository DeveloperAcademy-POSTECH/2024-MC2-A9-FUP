//
//  NotificationManger.swift
//  F-UP
//
//  Created by LeeWanJae on 5/22/24.
//

import SwiftUI
import UserNotifications

class NotificationManger {
    @AppStorage("currentExpressionIndex") private var currentExpressionIndex: Int = 0
        
    func setNotiAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            } 
            if success {
                print("Noti All Set")
                self.setDailyNoti()
            }
        }
    }
    
    func setDailyNoti() {
        print("setDailyNoti")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
        self.setNotiContent()
    }
    
    func setNotiContent() {
        print("setNotiContent")
        
        let content = UNMutableNotificationContent()
        content.title = "오늘의 챌린지를 수행해보세요"
        content.body = "\"\(dummyExpressions[currentExpressionIndex])\""
        content.sound = .default
        
        currentExpressionIndex = (currentExpressionIndex + 1) % dummyExpressions.count
        
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

var dummyExpressions = [
    "당신을 처음 본 순간, 내 심장은 멈춘 줄 알았어요.",
    "당신의 미소는 내 하루를 밝히는 태양이에요.",
    "당신의 목소리는 나를 꿈꾸게 해요.",
    "당신의 눈동자에 빠져버렸어요.",
    "당신 없이 내 삶은 무의미해요.",
    "당신은 나의 완벽한 반쪽이에요.",
    "당신을 사랑하는 건 숨 쉬는 것만큼 자연스러워요.",
    "당신과 함께라면 어디든 천국이에요.",
    "당신은 내 삶의 전부에요.",
    "당신과 함께라면 어떤 어려움도 견딜 수 있어요.",
    "당신은 내 꿈의 실현이에요.",
    "당신의 손을 잡는 순간, 모든 것이 완벽해져요.",
    "당신의 사랑이 나를 완성해요.",
    "당신의 존재가 나를 살아가게 해요.",
    "당신은 내 인생 최고의 선물이야.",
    "당신을 생각하면 가슴이 벅차올라요.",
    "당신의 사랑이 내 삶의 원동력이에요.",
    "당신의 따뜻한 품에 안기고 싶어요.",
    "당신의 웃음소리는 내게 가장 아름다운 음악이에요.",
    "당신과 함께하는 시간이 가장 소중해요.",
    "당신의 눈빛만으로도 모든 게 괜찮아져요.",
    "당신의 입맞춤은 마법 같아요.",
    "당신과 함께라면 평생을 함께하고 싶어요.",
    "당신은 나의 영원한 사랑이에요.",
    "당신과의 추억이 내 인생을 채워줘요.",
    "당신의 사랑이 내 마음을 따뜻하게 해줘요.",
    "당신의 손길이 내게 가장 큰 위안이에요.",
    "당신의 향기가 내게 행복을 가져다줘요.",
    "당신과 함께 있으면 세상이 다 아름다워요.",
    "당신은 내 인생의 가장 큰 기쁨이에요."
]
