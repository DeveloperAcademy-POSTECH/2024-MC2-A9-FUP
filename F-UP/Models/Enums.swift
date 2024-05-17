//
//  EnumManager.swift
//  F-UP
//
//  Created by 박현수 on 5/15/24.
//

import Foundation

enum ChallengeStep: Int, Codable {
    case notStarted = 0
    case recordingCompleted = 1
    case ChallengeCompleted = 2
}

enum Target: String, Codable, CaseIterable {
    case family = "가족"
    case friend = "친구"
    case acquaintance = "지인"
    case lover = "연인"
}

enum FeelingValue: Int, Codable {
    case veryUncomfortable = 0
    case uncomfortable = 1
    case neutral = 2
    case comfortable = 3
    case veryComfortable = 4
}

enum ReactionValue: Int, Codable {
    case veryBad = 0
    case bad = 1
    case neutral = 2
    case good = 3
    case veryGood = 4
}
