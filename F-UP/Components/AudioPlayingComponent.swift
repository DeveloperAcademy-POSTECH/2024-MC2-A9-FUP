//
//  AudioPlayingComponent.swift
//  F-UP
//
//  Created by namdghyun on 5/21/24.
//

import SwiftUI

struct AudioPlayingComponent: View {
    @Environment(AVFoundationManager.self) var avfoundationManager
    // 30개 구간 각각의 재생 상태를 확인하는 배열
    @State private var isPlayedArray: [Bool] = Array(repeating: false, count: 30)
    var audioLevels: [CGFloat]
    var audioLength: TimeInterval
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            ForEach(audioLevels.indices, id: \.self) { index in
                let height = max(8, audioLevels[index] * 200)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isPlayedArray[index] ? Theme.point : Color.gray)
                    .frame(width: 3, height: height)
                    .padding(.horizontal, -5)
            }
        }
        .onChange(of: avfoundationManager.playingTime) { oldValue, newValue in
            updateIsPlayedArray()
        }
    }
    
    /// 1. 현재 재생 중인 위치를 기준으로 해당 인덱스의 막대가 재생되었는지 여부를 계산한다.
    /// 2. 인덱스를 audioLevels의 개수인 30으로 나누어 인덱스를 0에서 1 사이의 값으로 정규화한다.
    /// 3. playingTime을 recordLength로 나누어 현재 재생 위치를 전체 녹음 길이에 대한 비율로 나타낸다.
    /// 4. 인덱스의 정규화된 값이 현재 재생 위치의 비율보다 작으면 해당 인덱스의 막대는 재생된 상태로 간주한다.
    /// 5. 30개 구간 각각의 재생 상태를 업데이트한다. "다시 녹음하기"를 누르면 재생 상태가 초기화되도록 onChnage에 넣는다.
    private func updateIsPlayedArray() {
        for index in avfoundationManager.audioLevels.indices {
            isPlayedArray[index] = Double(index) / Double(audioLevels.count) < avfoundationManager.playingTime / avfoundationManager.recordLength
        }
    }
}

//#Preview {
//    AudioPlayingComponent()
//        .environment(AVFoundationManager())
//}
