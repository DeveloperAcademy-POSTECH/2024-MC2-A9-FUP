//
//  ReviewWriteView.swift
//  F-UP
//
//  Created by namdghyun on 5/17/24.
//

import SwiftUI

struct TargetSelectView: View {
    @State var nameTextField = ""
    @State var selectedTarget: String = ""
    
    let target: [Target] = Target.allCases
    let columns = [GridItem(.adaptive(minimum: 152, maximum: 192), spacing: 9, alignment: .leading)]
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0) {
                Text("기록하기")
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
                                .frame(idealWidth: geo.size.width/2-9, idealHeight: geo.size.height/4-18)
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
                                    }
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
                Spacer()
                let isComplete: Bool = selectedTarget != ""
                Button(action: {
                    ///
                }, label: {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(idealWidth: 373, maxHeight: 50)
                        .background(isComplete ? Theme.point : Theme.subblack)
                        .cornerRadius(Theme.round)
                        .dropShadow(opacity: 0.15)
                        .overlay {
                            Text("다음으로 넘어가기")
                                .font(.headline .weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(isComplete ? Theme.white : Theme.white)
                        }
                }).disabled(!isComplete)
            }
            .padding(.horizontal, Theme.padding)
            .background(Theme.background)
        }
    }
}

#Preview {
    TargetSelectView()
}
