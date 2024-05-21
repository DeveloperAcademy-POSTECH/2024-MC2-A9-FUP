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
    
    @State private var sliderValue: Double = 0
    @State private var navigationToNextView: Bool = false
    
    private let emojis = ["😂", "😅", "😊", "😁", "🥰"]
    private let strings = ["많이 어색해요", "어색해요", "보통이에요", "익숙해요", "많이 익숙해요"]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text("기분이 어땠나요?")
                        .font(.title2 .weight(.bold))
                        .padding(.top, 38)
                    Text(emojis[Int(sliderValue / 25)]).font(.system(size: 220))
                        .padding(.top, 43)
                        .animation(.spring, value: sliderValue)
                    Text(strings[Int(sliderValue / 25)])
                        .font(.title2 .weight(.bold))
                        .padding(.top, 47)
                        .padding(.bottom, 38)
                        .animation(.spring, value: sliderValue)
                }
                .frame(width: 353)
                .background(Theme.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.round))
                .padding(.top, 27)
                
                CustomSlider(value: $sliderValue, in: 0...100, step: 25)
                    .frame(height: 38)
                    .padding(.top, 22)
                    .animation(.spring, value: sliderValue)
                HStack(spacing: 0) {
                    Text("어색해요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                    Spacer()
                    Text("익숙해요").font(.footnote .weight(.bold)).foregroundStyle(Theme.semiblack)
                }
                .padding(.top, 8)
                .padding(.horizontal, 7)
                Spacer()
                
                Button {
                    if navigationToNextView {
                        navigationToNextView = false
                    } else {
                        navigationToNextView = true
                    }
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
                .navigationDestination(isPresented: $navigationToNextView) {
                    ReactionView(showModal: $showModal)
                }
                
                
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
    MyMoodView(showModal: .constant(true))
}
