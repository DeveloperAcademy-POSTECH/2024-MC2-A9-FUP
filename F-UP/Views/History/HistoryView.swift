//
//  HistoryView.swift
//  F-UP
//
//  Created by namdghyun on 5/16/24.
//

// TODO: 필터 구현 시 클릭된 필터 히스토리 뷰에 표출
// 선택된 타겟을 갖고 있는 녀석들만.
// TODO: SwiftData로 Data 대체
import SwiftUI
import SwiftData

struct HistoryView: View {
    @State private var isShowingModal = false
    @State private var selectedMonth: String = "선택없음"
    @State private var selectedTarget: Target?
    @State private var settingsDetent = PresentationDetent.medium
    @State private var filterData: [History] = []
    @Query private var items: [History]
    
    var body: some View {
        HistoryViewHandler(count: items.count, isShowingModal: $isShowingModal, filterData: filterData)
                .onAppear {
                    filterData = items
                }
            .sheet(isPresented: $isShowingModal, content: {
                HistoryFilterView(selectedMonth: $selectedMonth, selectedTarget: $selectedTarget, isShowingModal: $isShowingModal)
                    .presentationDetents(
                        [.medium],
                        selection: $settingsDetent
                    )
                    .onDisappear {
                        combinedFilter()
                    }
            })
    }
}

@ViewBuilder
private func HistoryViewHandler(count: Int, isShowingModal: Binding<Bool>, filterData: [History]) -> some View {
    if count == 0 {
        EmptyHistoryView()
    } else {
        HasDateHistoryView(isShowingModal: isShowingModal, filterData: filterData)
    }
}

private func HasDateHistoryView(isShowingModal: Binding<Bool>, filterData: [History]) -> some View {
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
                Button {
                    isShowingModal.wrappedValue.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(Theme.point)
                }
            }
            .padding(.horizontal, Theme.padding)
            .padding(.bottom, 28)
            
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

extension HistoryView {
    private func combinedFilter() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yy년MM월"
           
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
