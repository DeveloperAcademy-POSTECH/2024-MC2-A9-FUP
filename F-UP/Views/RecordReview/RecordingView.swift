//
//  VoiceRecordingView.swift
//  F-UP
//
//  Created by namdghyun on 5/19/24.
//

import SwiftUI

struct RecordingView: View {
    @Environment(AVFoundationManager.self) var avfoundationManager
    @Binding var showModal: Bool
    @State var history: History
    
    //    @State private var isMicSelected: Bool = true
    @State private var navigationToNextView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0) {
                    Text("오늘의 표현")
                        .font(.footnote .weight(.regular))
                        .foregroundColor(Theme.semiblack)
                        .padding(.top, 34)
                        .padding(.bottom, 3)
                    Text("“\(history.expression)”")
                        .font(.title3 .weight(.bold))
                        .foregroundColor(Theme.black)
                        .padding(.bottom, 115)
                    
                    ZStack {
                        if avfoundationManager.isRecording {
                            if avfoundationManager.audioLevel > 0.1 {
                                Circle()
                                    .fill(Color(hex: 0xFF8E75))
                                    .frame(width: 321, height: 321)
                                    .opacity(0.1)
                            }
                            
                            if avfoundationManager.audioLevel > 0.07 {
                                Circle()
                                    .fill(Color(hex: 0xFF8E75))
                                    .frame(width: 283, height: 283)
                                    .opacity(0.15)
                            }
                            
                            if avfoundationManager.audioLevel > 0.03 {
                                Circle()
                                    .fill(Color(hex: 0xFF8E75))
                                    .frame(width: 241, height: 241)
                                    .opacity(0.25)
                            }
                        }
                        
                        Circle()
                            .fill(avfoundationManager.isRecording ? Color(hex: 0xFF8E75) : Theme.point)
                            .frame(width: 204, height: 204)
                        
                        Image(systemName: "mic")
                            .resizable()
                            .frame(width: 63, height: 94)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 204, height: 204)
                    .padding(.bottom, 115)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if avfoundationManager.isRecording {
                                navigationToNextView = true
                                avfoundationManager.isRecording = false
                                avfoundationManager.stopRecording()
                                HapticManager.sharedInstance.generateHaptic(.success)
                            } else {
                                HapticManager.sharedInstance.generateHaptic(.medium(times: 1))
                                avfoundationManager.isRecording = true
                                avfoundationManager.startRecording(fileName: history.date.dateToString())
                            }
                        }
                    }
                    .navigationDestination(isPresented: $navigationToNextView) {
                        ReviewRecordingView(showModal: $showModal, history: history)
                    }
                    .onChange(of: avfoundationManager.audioLevel) { oldValue, newValue in
                        HapticManager.sharedInstance.generateHaptic(.light(times: 1))
                    }
                    
                    Text(avfoundationManager.isRecording ? "듣고 있어요" : "오늘의 표현을 실제로 따라해보세요")
                        .font(.body .weight(.bold))
                        .foregroundStyle(avfoundationManager.isRecording ? Theme.black : Theme.semiblack)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.padding)
                .navigationTitle("말하기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("취소") {
                        avfoundationManager.stopRecording()
                        avfoundationManager.deleteRecording()
                        showModal = false
                    }
                    .tint(Theme.point)
                }
                .onAppear {
                    HapticManager.sharedInstance.prepareHapticEngine()
                    avfoundationManager.requestPermission { success in
                        if !success {
                            showModal = false
                            print("마이크 권한이 없습니다.")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecordingView(showModal: .constant(true), history: History(date: Date(), streak: 0, challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral))
        .environment(AVFoundationManager())
}
