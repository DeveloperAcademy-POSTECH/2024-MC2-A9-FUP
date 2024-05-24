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
    
    @Binding var showModal: Bool
    var history: History
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("오늘의 표현")
                    .padding(.top, 34)
                    .font(.footnote .weight(.regular))
                    .foregroundColor(Theme.semiblack)
                    .padding(.bottom, 3)
                Text("“\(history.expression)”")
                    .font(.title3 .weight(.bold))
                    .foregroundColor(Theme.black)
                    .padding(.bottom, 34)
                
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(Theme.white)
                    .frame(maxHeight: 418)
                    .overlay {
                        //                        if avfoundationManager.audioFilename != nil {
                        VStack {
                            Spacer()
                            //                                Image("TempWaveImage")
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
                        //                        } else {
                        //                            Text("녹음한 내용이 없습니다.").font(.callout .weight(.semibold)).foregroundStyle(Theme.semiblack)
                        //                        }
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
                    swiftDataManager.updateHistoryAfterRecording(modelContext: modelContext, history: history, audioURL: avFoundationManager.getCurrentRecordingPath()!, audioLevels: avFoundationManager.audioLevels, audioLength: avFoundationManager.recordLength)
                    refreshTrigger.trigger.toggle()
                    showModal = false
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
                
                showModal = false
            }
            .tint(Theme.point)
        }
    }
}

#Preview {
    ReviewRecordingView(showModal: .constant(true), history: History(date: Date(), streak: 0, challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral))
        .environment(AVFoundationManager())
        .environment(SwiftDataManager())
        .environment(RefreshTrigger())
}
