//
//  ReviewRecordingView.swift
//  F-UP
//
//  Created by namdghyun on 5/18/24.
//

import SwiftUI

struct ReviewRecordingView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showModal: Bool
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("오늘의 표현")
                    .padding(.top, 34)
                    .font(.footnote .weight(.regular))
                    .foregroundColor(Theme.semiblack)
                    .padding(.bottom, 3)
                Text("“오늘 하루도 정말 수고 많았어.”")
                    .font(.title3 .weight(.bold))
                    .foregroundColor(Theme.black)
                    .padding(.bottom, 34)
                
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(Theme.white)
                    .frame(maxHeight: 418)
                    .overlay {
                        VStack {
                            Spacer()
                            Image("TempWaveImage")
                            Spacer()
                            Button {
                                // 녹음 재생 기능 구현
                            } label: {
                                Label(
                                    title: { Text("Play") },
                                    icon: { Image(systemName: "play.fill") }
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
                    showModal = false
                    
                    // 녹음한 내용 저장하고 챌린지 단계 변경
                    // ...
                    
                } label : {
                    RoundedRectangle(cornerRadius: Theme.round)
                        .fill(Theme.point)
                        .dropShadow(opacity: 0.2)
                        .frame(width: 353, height: 50)
                        .overlay {
                            Text("다음으로 넘어가기")
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
                showModal = false
            }
            .tint(Theme.point)
        }
    }
}

#Preview {
    ReviewRecordingView(showModal: .constant(true))
}
