//
//  AudioPlayingComponent.swift
//  F-UP
//
//  Created by namdghyun on 5/21/24.
//

import SwiftUI

struct AudioPlayingComponent: View {
    @Environment(AVFoundationManager.self) var avfoundationManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            ForEach(avfoundationManager.audioLevels.indices, id: \.self) { index in
                /*
                현재 재생 중인 위치를 기준으로 해당 인덱스의 막대가 재생되었는지 여부를 계산한다.
                인덱스를 audioLevels의 개수인 30으로 나누어 인덱스를 0에서 1 사이의 값으로 정규화한다.
                playingTime을 recordLength로 나누어 현재 재생 위치를 전체 녹음 길이에 대한 비율로 나타낸다.
                인덱스의 정규화된 값이 현재 재생 위치의 비율보다 작으면 해당 인덱스의 막대는 재생된 상태로 간주한다.
                 */
                let isPlayed = Double(index) / 30.0 < avfoundationManager.playingTime / avfoundationManager.recordLength
                
                // audioLevel의 높이를 동적으로 계산하고, 가장 작은 높이가 8이 되도록 계산한다.
                let height = max(8, avfoundationManager.audioLevels[index] * 200)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isPlayed ? Theme.point : Color.gray)
                    .frame(width: 3, height: height)
                    .padding(.horizontal, -5)
            }
        }
    }
}

#Preview {
    AudioPlayingComponent()
        .environment(AVFoundationManager())
}
