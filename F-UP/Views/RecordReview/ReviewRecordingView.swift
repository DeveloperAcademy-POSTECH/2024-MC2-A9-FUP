//
//  ReviewRecordingView.swift
//  F-UP
//
//  Created by namdghyun on 5/18/24.
//

import SwiftUI

struct ReviewRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(AVFoundationManager.self) var avFoundationManager
    @Environment(SwiftDataManager.self) var swiftDataManager
    @Environment(RefreshTrigger.self) var refreshTrigger
    
    @State var cvm: ChallengeViewModel
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("오늘의 표현")
                    .padding(.top, 34)
                    .font(.footnote .weight(.regular))
                    .foregroundColor(Theme.semiblack)
                    .padding(.bottom, 3)
                Text("“\(cvm.dummyExpression[cvm.expressionIndex].forceCharWrapping))”")
                    .font(.title3 .weight(.bold))
                    .foregroundColor(Theme.black)
                    .padding(.bottom, 34)
                
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(Theme.white)
                    .frame(maxHeight: 418)
                    .overlay {
                        VStack {
                            Spacer()
                            AudioPlayingComponent(audioLevels: avFoundationManager.audioLevels, audioLength: avFoundationManager.recordLength)
                            Spacer()
                            Button {
                                HapticManager.shared.generateHaptic(.light(times: 1))
                                // 녹음 재생 기능 구현
                                if avFoundationManager.isPlaying {
                                    avFoundationManager.stopPlaying()
                                } else {
                                    avFoundationManager.playRecording()
                                }
                            } label: {
                                Label(
                                    title: { Text(avFoundationManager.isPlaying ? "Stop" : "Play") },
                                    icon: { Image(systemName: avFoundationManager.isPlaying ? "square.fill" : "play.fill") }
                                )
                            }
                            .controlSize(.small)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 20))
                            .tint(Theme.point)
                            .padding(.bottom, 24)
                        }
                    }
                    .padding(.bottom, 38)
                
                Button {
                    HapticManager.shared.generateHaptic(.light(times: 1))
                    // 녹음 삭제하고 다시 녹음
                    avFoundationManager.stopPlaying()
                    avFoundationManager.deleteRecording()
                    dismiss()
                } label : {
                    RoundedRectangle(cornerRadius: Theme.round)
                        .fill(Theme.white)
                        .dropShadow(opacity: 0.1)
                        .frame(width: 353, height: 50)
                        .overlay {
                            Text("다시 녹음하기")
                                .font(.headline .weight(.bold))
                                .foregroundStyle(Theme.point)
                        }
                        .padding(.bottom, 13)
                }
                
                Button {
                    avFoundationManager.stopPlaying()
                    swiftDataManager.updateHistoryAfterRecording(modelContext: modelContext, history: cvm.todaysHistory!, audioURL: avFoundationManager.getCurrentRecordingPath()!, audioLevels: avFoundationManager.audioLevels, audioLength: avFoundationManager.recordLength)
                    refreshTrigger.trigger.toggle()
                    cvm.showModal = false
                    HapticManager.shared.generateHaptic(.success)
                } label : {
                    RoundedRectangle(cornerRadius: Theme.round)
                        .fill(Theme.point)
                        .dropShadow(opacity: 0.2)
                        .frame(width: 353, height: 50)
                        .overlay {
                            Text("첫 번째 챌린지 완료하기")
                                .font(.headline .weight(.bold))
                                .foregroundStyle(Theme.white)
                        }
                }
                Spacer()
            }
            .padding(.horizontal, Theme.padding)
        }
        .navigationTitle("말하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            Button("취소") {
                avFoundationManager.stopPlaying()
                avFoundationManager.deleteRecording()
                
                cvm.showModal = false
            }
            .tint(Theme.point)
        }
    }
}
