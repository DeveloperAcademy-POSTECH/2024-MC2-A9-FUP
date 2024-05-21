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
    
    func addHistory(modelContext: ModelContext, expression: String) {
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
                expression: expression,
                audioURL: audioURL,
                target: .family,
                specificTarget: nil,
                feelingValue: .veryComfortable,
                reactionValue: .veryGood
            )
            modelContext.insert(newHistory)
            
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteHistorys(modelContext: ModelContext, offsets: IndexSet, histories: [History]) {
        withAnimation {
            for index in offsets {
                modelContext.delete(histories[index])
            }
        }
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateHistoryAfterRecording(modelContext: ModelContext, history: History, audioURL: URL) {
            withAnimation {
                history.audioURL = audioURL
                history.challengeStep = .recordingCompleted
                print("ok")
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
}

//let uuid = UUID()
//var date: Date
//var isPerformed = false
//var challengeStep: ChallengeStep
//var expression: String
//var audioURL : URL
//var target: Target
//var specificTarget: String?
//var feelingValue: FeelingValue
//var reactionValue: ReactionValue
