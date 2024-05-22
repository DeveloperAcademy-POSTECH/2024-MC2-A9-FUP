//
//  HistoryView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @State private var isShowingModal = false
    @State private var selectedMonth: String = "전체"
    @State private var selectedTarget: Target?
    @State private var filterData: [History] = []
    @Query private var items: [History]
    
    var body: some View {
        HistoryViewHandler(count: items.count, isShowingModal: $isShowingModal, filterData: filterData, selectedMonth: $selectedMonth, selectedTarget: $selectedTarget)                
            .onAppear {
                    filterData = items
                }
            .sheet(isPresented: $isShowingModal, content: {
                HistoryFilterView(selectedMonth: $selectedMonth, selectedTarget: $selectedTarget, isShowingModal: $isShowingModal)
                    .presentationDetents(
                        [.height(330)]
                    )
                    .onDisappear {
                        combinedFilter()
                    }
            })
    }
}

@ViewBuilder
private func HistoryViewHandler(count: Int, isShowingModal: Binding<Bool>, filterData: [History], selectedMonth: Binding<String>, selectedTarget: Binding<Target?>) -> some View {
    if count == 0 {
        EmptyHistoryView()
    } else {
        HasDateHistoryView(isShowingModal: isShowingModal, filterData: filterData, selectedTarget: selectedTarget, selectedMonth: selectedMonth)
    }
}

private func HasDateHistoryView(isShowingModal: Binding<Bool>, filterData: [History], selectedTarget: Binding<Target?>, selectedMonth: Binding<String> ) -> some View {
    return NavigationStack {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("챌린지 표현")
                    .font(.title)
                    .foregroundStyle(Theme.black)
                    .bold()
                Text("\(filterData.count)")
                    .font(.footnote)
                    .foregroundStyle(Theme.point)
                    .padding(.leading, 8)
                    .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 8) {
                    if selectedTarget.wrappedValue != nil {
                        CurrentTargetFilter(selectedTarget: selectedTarget)
                    }
                    if selectedMonth.wrappedValue !=  "전체" {
                        CurrentMonthFilter(selectedMonth: selectedMonth)
                    }
                }
                .padding(.trailing, 8)
                
                Button {
                    isShowingModal.wrappedValue.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(Theme.point)
                }
            }
            .padding(.horizontal, Theme.padding)
            .padding(.bottom, 28)
            .padding(.top, 11)
            
            ScrollView {
                ForEach(filterData, id: \.id) { history in
                    NavigationLink(destination: HistoryDetailView(history: history)) {
                        RoundedRectangle(cornerRadius: Theme.round)
                            .fill(Theme.white)
                            .frame(width: 353, height: 92)
                            .dropShadow(opacity: 0.15)
                            .overlay {
                                Text(history.expression)
                                    .font(.title3)
                                    .foregroundStyle(Theme.black)
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom, 10)
                            .padding(.horizontal, Theme.padding)
                    }
                }
            }
        }
        .background(Theme.background)
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
                Text("0")
                    .foregroundStyle(Theme.point)
                    .padding(.leading, 8)
                Spacer()
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundStyle(Theme.point)
            }
            .padding([.leading, .top, .trailing], Theme.padding)
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

private func CurrentTargetFilter(selectedTarget: Binding<Target?>) -> some View {
    return VStack {
        RoundedRectangle(cornerRadius: Theme.round)
            .fill(Theme.point)
            .frame(width: 37, height: 20)
            .overlay {
                Text("\(selectedTarget.wrappedValue?.rawValue ?? "")")
                    .font(.caption2 .weight(.bold))
                    .foregroundStyle(Theme.white)
            }
    }
}

private func CurrentMonthFilter(selectedMonth: Binding<String>) -> some View {
    return VStack {
        RoundedRectangle(cornerRadius: Theme.round)
            .fill(Theme.point)
            .frame(width: 37, height: 20)
            .overlay {
                Text("\(selectedMonth.wrappedValue)")
                    .font(.caption2 .weight(.bold))
                    .foregroundStyle(Theme.white)
            }
    }
}

extension HistoryView {
    private func combinedFilter() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yy년M월"
           
           filterData = items.filter { item in
               let targetCondition = (selectedTarget == nil || item.target == selectedTarget) && item.isPerformed
               let dateCondition = selectedMonth == "전체" || dateFormatter.string(from: item.date).contains(selectedMonth)
               return targetCondition && dateCondition
           }
       }
}

#Preview {
    HistoryView()
}
