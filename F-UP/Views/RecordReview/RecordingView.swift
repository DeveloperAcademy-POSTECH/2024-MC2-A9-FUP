//
//  VoiceRecordingView.swift
//  F-UP
//
//  Created by namdghyun on 5/19/24.
//

import SwiftUI

struct RecordingView: View {
    @State var isMicSelected: Bool = false
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("말하기")
                    .font(.headline .weight(.bold))
                    .foregroundColor(Theme.black)
                    .padding(.top, 17)
                    .padding(.bottom, 44)
                Text("오늘의 표현")
                    .font(.footnote .weight(.regular))
                    .foregroundColor(Theme.semiblack)
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
                        isMicSelected.toggle()
                    }
                    
                    // Recording..
                }
                
                Text(isMicSelected ? "듣고 있어요" : "오늘의 표현을 실제로 따라해보세요")
                    .font(.body .weight(.bold))
                    .foregroundStyle(Theme.semiblack)
                
                Spacer()
            }
            .padding(.horizontal, Theme.padding)
        }
    }
}

#Preview {
    RecordingView()
}
