//
//  SwiftDataManager.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//
import Foundation
import SwiftData
import SwiftUI

@Observable
final class SwiftDataManager {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addHistory() {
        withAnimation {
            guard let audioURL = URL(string: "https://www.example.com")
            else {
                print("Invalid URL")
                return
            }
            
            let newHistory = History(
                date: Date(),
                isPerformed: false,
                challengeStep: .notStarted,
                expression: "Test Expression",
                audioURL: audioURL,
                target: .family,
                specificTarget: nil,
                feelingValue: .veryComfortable,
                reactionValue: .veryGood
            )
            modelContext.insert(newHistory)
        }
    }

    func deleteHistorys(offsets: IndexSet, histories: [History]) {
        withAnimation {
            for index in offsets {
                modelContext.delete(histories[index])
            }
        }
    }
}
