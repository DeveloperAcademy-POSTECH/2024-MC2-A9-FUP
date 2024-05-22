//
//  ExpressionStreakWidget.swift
//  ExpressionStreakWidget
//
//  Created by 박현수 on 5/22/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("streak") var streak: Int = 0
    
    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), streak: 1, expression: "오늘의 표현")
        //        SimpleEntry(date: Date(), emoji: "😀")
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
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 1
        dateComponents.day = 1
        
        guard let specificDate = calendar.date(from: dateComponents) else {
            return SimpleEntry(date: Date(), streak: streak, expression: "너는 최고야")
        }
        
        let components = calendar.dateComponents([.day], from: specificDate, to: currentDate)
        
        guard let daysElapsed = components.day else {
            return SimpleEntry(date: Date(), streak: streak, expression: "너는 최고야")
        }
        
        let expressionIndex = daysElapsed % dummyExpression.count
        
        return SimpleEntry(date: Date(), streak: streak, expression: dummyExpression[expressionIndex])
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
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
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 1
        dateComponents.day = 1
        
        guard let specificDate = calendar.date(from: dateComponents) else {
            return
        }
        
        let components = calendar.dateComponents([.day], from: specificDate, to: currentDate)
        
        guard let daysElapsed = components.day else {
            return
        }
        
        let expressionIndex = daysElapsed % dummyExpression.count
        
        let entry = SimpleEntry(date: Date(), streak: streak, expression: dummyExpression[expressionIndex])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
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
        
        for minuteOffset in 0 ..< 5 {
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
            
            let expressionIndex = daysElapsed % dummyExpression.count
            
            let entryDate = calendar.date(byAdding: .minute, value: minuteOffset * 5, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, streak: streak, expression: dummyExpression[expressionIndex])
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let expression: String
}

struct ExpressionStreakWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        switch self.family {
        case .systemSmall:
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(entry.streak == 0 ? Theme.subblack : Theme.point)
                        Text("\(entry.streak)") //streak 변수
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(entry.streak == 0 ? Theme.subblack : Theme.point)
                    }.padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 9.75)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 9.75)
                                .stroke(entry.streak == 0 ? Theme.subblack : Theme.point, lineWidth: 1.5)
                        )
                    Text(entry.streak == 0 ? "챌린지가 끊겼어요." : "연속 챌린지 성공!")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(colorScheme == .light ? Theme.black : Theme.white)
                        .padding(.leading, 7)
                    
                }
                
                Image(entry.streak == 0 ? .characterwidget2 : .characterwidget1)
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea()
            .containerBackground(for: .widget) {
                colorScheme == .light ? Theme.white : Theme.black
            }
        case .systemMedium:
            VStack(spacing: 6) {
                Text("오늘의 표현")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.subblack)
                Text("“\(entry.expression)“")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .light ? Theme.black : Theme.white)
            }.containerBackground(for: .widget) {
                colorScheme == .light ? Theme.white : Theme.black
            }
        default:
            Text("Hi").containerBackground(for: .widget) {
                colorScheme == .light ? Theme.white : Theme.black
            }.containerBackground(for: .widget) {
                colorScheme == .light ? Theme.white : Theme.black
            }
        }
    }
}

struct ExpressionStreakWidget: Widget {
    let kind: String = "ExpressionStreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ExpressionStreakWidgetEntryView(entry: entry)
            } else {
                ExpressionStreakWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ExpressionStreakWidget()
} timeline: {
    SimpleEntry(date: Date(), streak: 1, expression: "오늘의 표현")
    SimpleEntry(date: Date(), streak: 1, expression: "오늘의 표현")
}
