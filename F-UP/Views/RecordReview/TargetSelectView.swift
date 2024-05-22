//
//  ReviewWriteView.swift
//  F-UP
//
//  Created by namdghyun on 5/17/24.
//

import SwiftUI

struct TargetSelectView: View {
    @Binding var showModal: Bool
    
    @State private var nameTextField = ""
    @State private var selectedTarget: String = ""
    @State private var selectedTargetEnum: Target? = nil
    @State private var navigationToNextView: Bool = false
    
    @State var history: History
    
    let target: [Target] = Target.allCases
    let columns = [
        GridItem(.flexible(), spacing: 9, alignment: .leading),
        GridItem(.flexible(), alignment: .leading)
    ]
    var isComplete: Bool {
        selectedTarget != ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(alignment: .center, spacing: 0) {
                            Text("오늘의 표현")
                                .font(.footnote .weight(.regular))
                                .foregroundColor(Theme.semiblack)
                                .padding(.top, 34)
                                .padding(.bottom, 3)
                            Text("“오늘 하루도 정말 수고 많았어.”")
                                .font(.title3 .weight(.bold))
                                .foregroundColor(Theme.black)
                                .padding(.bottom, 51)
                            Text("누구에게 이 따뜻함을 건냈나요?")
                                .font(.body .weight(.bold))
                                .foregroundColor(Theme.black)
                                .padding(.bottom, 10)
                            HStack {
                                LazyVGrid(columns: columns, spacing: 9) {
                                    ForEach(target, id: \.self) { target in
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(idealWidth: 172, idealHeight: 172)
                                            .background(selectedTarget == target.rawValue ? Theme.point : Theme.white)
                                            .cornerRadius(Theme.round)
                                            .dropShadow(opacity: 0.15)
                                            .overlay {
                                                VStack {
                                                    Spacer()
                                                    Text("\(target.rawValue)")
                                                        .font(.body .weight(.bold))
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(selectedTarget == target.rawValue ? Theme.white : Theme.black)
                                                        .padding(.bottom, 11)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation(.easeIn(duration: 0.1)) {
                                                    let isSelected = selectedTarget == target.rawValue
                                                    isSelected ? (selectedTarget = "") : (selectedTarget = target.rawValue)
                                                    
                                                    if selectedTargetEnum == target {
                                                        selectedTargetEnum = nil
                                                    }
                                                    else {
                                                        selectedTargetEnum = target
                                                    }
                                                }
                                                nameTextField = ""
                                            }
                                    }
                                }
                            }
                            .padding(.bottom, 13)
                            ForEach(target, id: \.self) { target in
                                if selectedTarget == target.rawValue {
                                    TextField("ex) 내 \(target.rawValue) 이름", text: $nameTextField)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 11)
                                        .background(Theme.white)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 8)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.padding)
                    .navigationTitle("기록하기")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button("취소") {
                            showModal = false
                        }
                        .tint(Theme.point)
                    }
                    
                    Button {
//                        if navigationToNextView {
//                            navigationToNextView = false
//                        } else {
//                            navigationToNextView = true
//                        }
                        navigationToNextView = true
                    } label: {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 353, height: 50)
                            .background(isComplete ? Theme.point : Theme.subblack)
                            .cornerRadius(Theme.round)
                            .dropShadow(opacity: 0.15)
                            .overlay {
                                Text("다음으로 넘어가기")
                                    .font(.headline .weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(isComplete ? Theme.white : Theme.white)
                            }
                    }
                    .disabled(!isComplete)
                    .navigationDestination(isPresented: $navigationToNextView) {
                        if nameTextField.isEmpty {
                            MyMoodView(showModal: $showModal, history: history, target: selectedTargetEnum ?? .family, specificTarget: nil)
                        }
                        else {
                            MyMoodView(showModal: $showModal, history: history, target: selectedTargetEnum ?? .family, specificTarget: nameTextField)
                        }
                        
                    }
                    .padding(.bottom, 13)
                }
            }
        }
    }
}

#Preview {
    TargetSelectView(showModal: .constant(true), history: History(date: Date(), challengeStep: .challengeCompleted, expression: "ds", audioURL: URL(string: "https://www.example.com")!, audioLevels: Array(repeating: CGFloat(0.1), count: 30), audioLength: 0, target: .acquaintance, feelingValue: .neutral, reactionValue: .neutral))
        .environment(AVFoundationManager())
}
