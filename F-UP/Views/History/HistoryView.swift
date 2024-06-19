//
//  HistoryView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @State var historyViewModel = HistoryViewModel()
    
    var body: some View {
        HistoryViewHandler()
            .onAppear {
                historyViewModel.fetchHistories()
                historyViewModel.combinedFilter()
                }
            .sheet(isPresented: $historyViewModel.isShowingModal, content: {
                HistoryFilterView(historyViewModel: historyViewModel)
                    .presentationDetents(
                        [.height(250)]
                    )
                    .onDisappear {
                        historyViewModel.combinedFilter()
                    }
            })
    }
}

extension HistoryView {
    @ViewBuilder
    private func HistoryViewHandler() -> some View {
        if historyViewModel.count == 0 {
            EmptyHistoryView()
        } else {
            HasDateHistoryView()
        }
    }
    
    private func HasDateHistoryView() -> some View {
        return NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("챌린지 표현")
                        .font(.title)
                        .foregroundStyle(Theme.black)
                        .bold()
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "scroll.fill")
                                .font(.footnote .weight(.semibold))
                                .foregroundColor(Theme.point)
                            Text("\(historyViewModel.count)")
                                .font(.footnote .weight(.semibold))
                                .foregroundStyle(Theme.point)
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Theme.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.5)
                            .inset(by: 0.65)
                            .stroke(Theme.point, lineWidth: 1.3)
                    )
                    .padding(.leading, 10)
                    
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if historyViewModel.selectedTarget != nil {
                            CurrentTargetFilter()
                        }
//                        if historyViewModel.selectedMonth !=  "전체" {
//                            CurrentMonthFilter()
//                        }
                    }
                    .padding(.trailing, 8)
                    
                    Button {
                        HapticManager.shared.generateHaptic(.light(times: 1))
                        historyViewModel.isShowingModal.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundStyle(Theme.point)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.bottom, 13)
                .padding(.top, 11)
                
                ScrollView {
                    ForEach(historyViewModel.filterData, id: \.id) { history in
                        NavigationLink(destination: HistoryDetailView(history: history).onAppear { HapticManager.shared.generateHaptic(.light(times: 1)) }) {
                            RoundedRectangle(cornerRadius: Theme.round)
                                .fill(Theme.white)
                                .frame(height: 92)
                                .frame(maxWidth: .infinity)
                                .dropShadow(opacity: 0.15)
                                .overlay {
                                    Text(history.expression)
                                        .font(.title3)
                                        .foregroundStyle(Theme.black)
                                        .fontWeight(.bold)
                                }.padding(.bottom, 10)
                        }.padding(.horizontal, Theme.padding)
                    }
                }.safeAreaPadding(.top, 15)
            }.background(Theme.background)
        }
    }
    
    private func EmptyHistoryView() -> some View {
        return NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("챌린지 표현")
                        .font(.title)
                        .foregroundStyle(Theme.black)
                        .bold()
                    HStack(alignment: .center, spacing: 10) {
                        HStack(spacing: 2) {
                            Image(systemName: "scroll.fill")
                                .font(.footnote .weight(.semibold))
                                .foregroundStyle(historyViewModel.count == 0 ? Theme.subblack : Theme.point)
                            Text("\(historyViewModel.count)")
                                .font(.footnote .weight(.semibold))
                                .foregroundStyle(historyViewModel.count == 0 ? Theme.subblack : Theme.point)
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Theme.background)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12.5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.5)
                            .inset(by: 0.65)
                            .stroke(historyViewModel.count == 0 ? Theme.subblack : Theme.point, lineWidth: 1.3)
                    )
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if historyViewModel.selectedTarget != nil {
                            CurrentTargetFilter()
                        }
                    //    if historyViewModel.selectedMonth != "전체" {
                    //        CurrentMonthFilter()
                    //    }
                    }
                    .padding(.trailing, 8)
                    
                    Button {
                        historyViewModel.isShowingModal.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundStyle(Theme.point)
                    }
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 11)
                .padding(.bottom, 28)
                Spacer()
                VStack(spacing: 0) {
                    Text("아직 기록이 없어요!")
                        .foregroundStyle(Theme.subblack)
                }
                Spacer()
            }
            .background(Theme.background)
        }
    }
    
    private func CurrentTargetFilter() -> some View {
        return VStack {
            RoundedRectangle(cornerRadius: Theme.round)
                .fill(Theme.point)
                .frame(width: 37, height: 20)
                .overlay {
                    Text("\(historyViewModel.selectedTarget?.rawValue ?? "")")
                        .font(.caption2 .weight(.bold))
                        .foregroundStyle(Theme.white)
                }
        }
    }
    
//    private func CurrentMonthFilter() -> some View {
//        return VStack {
//            RoundedRectangle(cornerRadius: Theme.round)
//                .fill(Theme.point)
//                .frame(width: 37, height: 20)
//                .overlay {
//                    Text("\(historyViewModel.selectedMonth)")
//                        .font(.caption2 .weight(.bold))
//                        .foregroundStyle(Theme.white)
//                }
//        }
//    }
}

#Preview {
    HistoryView()
}
