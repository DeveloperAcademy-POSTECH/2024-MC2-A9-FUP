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
    
    @State private var isMicSelected: Bool = false
    @State private var navigationToNextView: Bool = false
    
    var dummyAudioUrl: String = "dummy"
    
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
                    Text("“오늘 하루도 정말 수고 많았어.”")
                        .font(.title3 .weight(.bold))
                        .foregroundColor(Theme.black)
                        .padding(.bottom, 115)
                    
                    ZStack {
                        if isMicSelected {
                            Circle()
                                .fill(Theme.point)
                                .frame(width: 321, height: 321)
                                .opacity(0.1)
                            
                            Circle()
                                .fill(Theme.point)
                                .frame(width: 283, height: 283)
                                .opacity(0.15)
                            
                            Circle()
                                .fill(Theme.point)
                                .frame(width: 241, height: 241)
                                .opacity(0.25)
                        }
                        
                        Circle()
                            .fill(Theme.point)
                            .frame(width: 204, height: 204)
                        
                        Image(systemName: "mic")
                            .resizable()
                            .frame(width: 63, height: 94)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 204, height: 204)
                    .padding(.bottom, 115)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isMicSelected = true
                        }
                        
                        // Recording..
                        if avfoundationManager.isRecording {
                            isMicSelected = false
                            navigationToNextView = true
                            avfoundationManager.isRecording = false
                            avfoundationManager.stopRecording()
                            
                        } else {
                            avfoundationManager.isRecording = true
                            avfoundationManager.startRecording(fileName: dummyAudioUrl)
                        }
                    }
                    .navigationDestination(isPresented: $navigationToNextView) {
                        ReviewRecordingView(showModal: $showModal)
                    }
                    
                    Text(isMicSelected ? "듣고 있어요" : "오늘의 표현을 실제로 따라해보세요")
                        .font(.body .weight(.bold))
                        .foregroundStyle(isMicSelected ? Theme.black : Theme.semiblack)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.padding)
                .navigationTitle("말하기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("취소") {
                        avfoundationManager.deleteRecording()
                        showModal = false
                    }
                    .tint(Theme.point)
                }
            }
        }
    }
}

#Preview {
    
    RecordingView(showModal: .constant(true))
        .environment(AVFoundationManager())
}
