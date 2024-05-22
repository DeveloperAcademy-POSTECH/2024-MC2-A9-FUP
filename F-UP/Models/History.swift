//
//  History.swift
//  F-UP
//
//  Created by 박현수 on 5/14/24.
//

import Foundation
import SwiftData

@Model
final class History {
    let uuid = UUID()
    var date: Date
    var isPerformed = false
    var challengeStep: ChallengeStep
    var expression: String
    var audioURL : URL
    var audioLevels: [CGFloat]
    var audioLength: TimeInterval
    var target: Target
    var specificTarget: String?
    var feelingValue: FeelingValue
    var reactionValue: ReactionValue
    
    init(date: Date, isPerformed: Bool = false, challengeStep: ChallengeStep, expression: String, audioURL: URL, audioLevels: [CGFloat], audioLength: TimeInterval, target: Target, specificTarget: String? = nil, feelingValue: FeelingValue, reactionValue: ReactionValue) {
        self.date = date
        self.isPerformed = isPerformed
        self.challengeStep = challengeStep
        self.expression = expression
        self.audioURL = audioURL
        self.audioLevels = audioLevels
        self.audioLength = audioLength
        self.target = target
        self.specificTarget = specificTarget
        self.feelingValue = feelingValue
        self.reactionValue = reactionValue
    }
}
