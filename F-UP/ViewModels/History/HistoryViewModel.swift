//
//  HistoryViewModel.swift
//  F-UP
//
//  Created by LeeWanJae on 5/28/24.
//

import SwiftUI
import SwiftData

@Observable
class HistoryViewModel {
    let modelContext: ModelContext
    
    var isShowingModal = false
    var selectedTarget: Target?
    var filterData: [History] = []
    var histories: [History] = []
    var count: Int = 0
    //    var selectedMonth: String = "전체"
//    var months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월", "전체"].reversed()
    
    init() {
        modelContext = ModelContext(SwiftDataManager.shared.container)
    }
    
    func fetchHistories() {
        do {
            try histories = SwiftDataManager.shared.fetchHistories(modelContext: modelContext)
            print("histories Data: \(histories)")
        }
        catch {
            fatalError("fetch error \(error.localizedDescription)")
        }
    }
    
    
    func combinedFilter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년M월"
        filterData = histories.filter { item in
            let targetCondition = (selectedTarget == nil || item.target == selectedTarget) && item.isPerformed
//            let dateCondition = selectedMonth == "전체" || dateFormatter.string(from: item.date).contains(selectedMonth)
            return targetCondition/* && dateCondition*/
        }
        print("filterData Data: \(filterData)")
        count = filterData.count
    }
}
