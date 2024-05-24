//
//  SwiftDataManager.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import SwiftUI
import SwiftData

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
                streak: 0,
                isPerformed: false,
                challengeStep: .notStarted,
                expression: expression,
                audioURL: audioURL,
                audioLevels: [],
                audioLength: 0,
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

    func deleteHistory(modelContext: ModelContext, history: History) {
        withAnimation {
//            for index in offsets {
            modelContext.delete(history)
//            }
        }
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateHistoryAfterRecording(modelContext: ModelContext, history: History, audioURL: URL, audioLevels: [CGFloat], audioLength: TimeInterval) {
            withAnimation {
                
                history.audioURL = audioURL
                history.audioLevels = audioLevels.map { $0 * 0.7 } // 히스토리에 표시되는 오디오레벨의 크기 줄이기
                history.audioLength = audioLength
                history.challengeStep = .recordingCompleted
                print("ok")
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func updateHistoryAfterChallenge(modelContext: ModelContext, history: History, streak: Int, target: Target, specificTarget: String?, feelingValue: FeelingValue, reactionValue: ReactionValue) {
            withAnimation {
                history.isPerformed = true
                history.challengeStep = .challengeCompleted
                history.streak = streak
                history.target = target
                history.specificTarget = specificTarget
                history.feelingValue = feelingValue
                history.reactionValue = reactionValue
                print("ok2")
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
}
