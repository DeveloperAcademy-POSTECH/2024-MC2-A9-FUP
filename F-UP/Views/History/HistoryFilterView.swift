//
//  HistoryFilterView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/18/24.
//

import SwiftUI

struct HistoryFilterView: View {
    @Binding var selectedMonth: String
    @Binding var selectedTarget: Target?
    @Binding var isShowingModal: Bool
    var months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월", "전체"].reversed()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("대상")
                    .font(.headline .weight(.bold))
                    .padding(.leading, 26)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            HStack(spacing: 11) {
                ForEach(Target.allCases, id: \.self) { target in
                    TargetButton(
                        target: target,
                        isSelected: selectedTarget == target
                    ) {
                        if selectedTarget == target {
                            selectedTarget = nil
                        } else {
                            selectedTarget = target
                        }
                    }
                }
            }
            
            HStack {
                Text("월")
                    .foregroundStyle(Theme.black)
                    .font(.headline .weight(.bold))
                    .padding(.leading, 26)
                    .padding(.top, 25)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            Menu {
                ForEach(months, id: \.self) { month in
                    Button {
                        selectedMonth = month
                    } label: {
                        Text(month)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(.white)
                    .frame(width: 353, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: Theme.round)
                            .stroke( Theme.subblack ,lineWidth: 1)
                            .frame(width: 353, height: 50)
                        HStack(spacing: 0) {
                            Text(selectedMonth)
                                .foregroundStyle(Theme.black)
                                .padding(Theme.padding)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .padding(.trailing, Theme.padding)
                                .foregroundStyle(Theme.black)
                        }
                    }
            }
            
            Button {
                isShowingModal.toggle()
            } label: {
                RoundedRectangle(cornerRadius: Theme.round)
                    .fill(Theme.point)
                    .frame(width: 353, height: 50)
                    .overlay {
                        Text("필터 적용하기")
                            .foregroundStyle(Theme.white)
                    }
                    .padding(.top, 38)
                    .dropShadow(opacity: 0.2)
            }
        }
    }
}

private struct TargetButton: View {
    var target: Target
    var isSelected: Bool
    var action: () -> Void
    @State private var borderColor = Theme.subblack
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 26)
                .fill(isSelected ? Theme.point : Theme.white)
                .frame(width: 80, height: 45)
                .overlay {
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(isSelected ? Theme.point : Theme.subblack, lineWidth: 1)
                        .frame(width: 80, height: 45)
                    Text(target.rawValue)
                        .foregroundColor(isSelected ? Theme.white : Theme.semiblack)
                }
        }
    }
}

#Preview {
    HistoryFilterView(selectedMonth: .constant("1월"), selectedTarget: .constant(.family), isShowingModal: .constant(false))
}
