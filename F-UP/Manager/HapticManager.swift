//
//  HapticManager.swift
//  F-UP
//
//  Created by namdghyun on 5/24/24.
//

import SwiftUI
import CoreHaptics

class HapticManager {
    enum HapticStyle {
        case rigidTwice
        case success
        case light(times: Int)
        case medium(times: Int)
    }
    
    static let shared: HapticManager = HapticManager()
    private var engine: CHHapticEngine?
    
    private init() {
        startHapticEngine()
    }
    
    /// hapticEngine을 시작하는 함수
    private func startHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            guard let engine = engine else { return }
            engine.playsHapticsOnly = true
            engine.isAutoShutdownEnabled = true
            try engine.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    /// hapticEngine을 다시 시작하는 함수
    func resetHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        guard let engine = self.engine else { return }
        
        engine.stop()
        engine.stoppedHandler = { reason in
            print("\(reason)")
        }
        engine.resetHandler = {
            do {
                print("reseting core haptic engine")
                try engine.start()
            } catch {
                print("cannot reset core haptic engine")
            }
        }
    }
    
    /// 외부에서 Haptic에 접근하는 함수
    func generateHaptic(_ style: HapticStyle) {
        let pattern = self.generateHapticPattern(style)
        do {
            try self.playHaptic(pattern)
        } catch {
            print("Cannot play haptic")
        }
    }
    
    /// 햅틱 패턴을 만들어내는 함수
    private func generateHapticPattern(_ style: HapticStyle) -> CHHapticPattern? {
        switch style {
        // rigid twice
        case .rigidTwice:
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 2
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 1
            )
            
            let firstEvent = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            let secondEvent = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0.1
            )
            
            let pattern = try? CHHapticPattern(
                events: [firstEvent, secondEvent],
                parameters: []
            )
            return pattern
            
        // success
        case .success:
            let firstIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 1
            )
            let firstSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.4
            )
            let firstEvent = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [firstIntensity, firstSharpness],
                relativeTime: 0
            )
            
            let secondIntensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 2
            )
            let secondSharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.8
            )
            let secondEvent = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [secondIntensity, secondSharpness],
                relativeTime: 0.15
            )
            
            let pattern = try? CHHapticPattern(
                events: [firstEvent, secondEvent],
                parameters: []
            )
            return pattern
            
        case let .light(times: times):
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 0.5
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.3
            )
            
            var events: [CHHapticEvent] = [CHHapticEvent]()
            
            for i in 0 ..< times {
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: Double(i) * 0.1
                )
                events.append(event)
            }
            
            let pattern = try? CHHapticPattern(
                events: events,
                parameters: []
            )
            return pattern
            
        case let .medium(times: times):
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 0.7
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.5
            )
            
            var events: [CHHapticEvent] = [CHHapticEvent]()
            
            for i in 0 ..< times {
                let event = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: Double(i) * 0.1
                )
                events.append(event)
            }
            
            let pattern = try? CHHapticPattern(
                events: events,
                parameters: []
            )
            return pattern
        }
    }
    
    /// pattern에 따라 햅틱을 실행시키는 함수
    private func playHaptic(_ pattern: CHHapticPattern?) throws {
        // Generate haptic using the pattern above
        guard let givenPattern = pattern else { return }
        
        let player = try self.engine?.makePlayer(with: givenPattern)
        try player?.start(atTime: 0)
    }
}
