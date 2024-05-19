//
//  AVFoundationTestView.swift
//  F-UP
//
//  Created by 박현수 on 5/19/24.
//

import SwiftUI

struct AVFoundationTestView: View {
    @Environment(AVFoundationManager.self) var avfoundationManager
    @State var fileName = ""
    
    var body: some View {
        VStack {
            Text(avfoundationManager.isRecording ? "Recording..." : "Not Recording")
                .padding()
            TextField("input", text: $fileName)
            Button(action: {
                if avfoundationManager.isRecording {
                    avfoundationManager.stopRecording()
                } else {
                    avfoundationManager.startRecording(fileName: fileName)
                }
            }) {
                Text(avfoundationManager.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(avfoundationManager.isRecording ? Color.red : Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            if avfoundationManager.audioFilename != nil {
                Button(action: {
                    if avfoundationManager.isPlaying {
                        avfoundationManager.stopPlaying()
                    } else {
                        avfoundationManager.playRecording()
                    }
                }) {
                    Text(avfoundationManager.isPlaying ? "Stop Playing" : "Play Recording")
                        .padding()
                        .background(avfoundationManager.isPlaying ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    avfoundationManager.deleteRecording()
                }) {
                    Text("Delete Recording")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
