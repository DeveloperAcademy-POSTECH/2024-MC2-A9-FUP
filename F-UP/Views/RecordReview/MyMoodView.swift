//
//  MyMoodView.swift
//  F-UP
//
//  Created by namdghyun on 5/20/24.
//

import SwiftUI

struct MyMoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showModal: Bool
    
    @State var sliderValue: Double = 0
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("이 따뜻함을 건낸\n나의 기분은 어떠한가요?")
                        .font(.title2 .weight(.bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 28)
                    Text("☺️").font(.system(size: 220))
                        .padding(.top, 33)
                    Text("아직은 많이 어색해요")
                        .font(.title2 .weight(.bold))
                        .padding(.top, 37)
                        .padding(.bottom, 38)
                }
                .frame(width: 353)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                .padding(.top, 27)
                
                CustomSlider(value: $sliderValue, in: 0...100, step: 25)
                    .padding(.top, 22)
                    .animation(.spring, value: sliderValue)
                
                Spacer()
            }
            .padding(.horizontal, Theme.padding)
            .navigationTitle("기록하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                            Text("뒤로")
                        }
                        .foregroundStyle(Theme.point)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("취소") {
                        showModal = false
                    }
                    .tint(Theme.point)
                }
            }
        }
        
    }
}


#Preview {
    MyMoodView(showModal: .constant(true), sliderValue: 0.5)
}
