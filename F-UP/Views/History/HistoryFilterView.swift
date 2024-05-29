//
//  HistoryFilterView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/18/24.
//

import SwiftUI

struct HistoryFilterView: View {
    @Bindable var historyViewModel: HistoryViewModel
  
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
                        isSelected: historyViewModel.selectedTarget == target
                    ) {
                        HapticManager.shared.generateHaptic(.light(times: 1))
                        if historyViewModel.selectedTarget == target {
                            historyViewModel.selectedTarget = nil
                        } else {
                            historyViewModel.selectedTarget = target
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
                ForEach(historyViewModel.months, id: \.self) { month in
                    Button {
                        HapticManager.shared.generateHaptic(.light(times: 1))
                        historyViewModel.selectedMonth = month
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
                            Text(historyViewModel.selectedMonth)
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
                HapticManager.shared.generateHaptic(.success)
                historyViewModel.isShowingModal.toggle()
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
extension HistoryFilterView {
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
                            .font(.callout .weight(.bold))
                            .foregroundColor(isSelected ? Theme.white : Theme.semiblack)
                    }
            }
        }
    }
}

#Preview {
    HistoryFilterView(historyViewModel: HistoryViewModel())
}
