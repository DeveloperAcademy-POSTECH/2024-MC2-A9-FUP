//
//  ContentView.swift
//  F-UP
//
//  Created by 박현수 on 5/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SwiftDataManager.self) private var swiftDataManager
    @Query private var items: [History]

    @State var todayHistories: [History] = []
    @State var yesterdayHistories: [History] = []
    @State private var currentDateString: String = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    @AppStorage("streak") var streak: Int = 0
    
    var body: some View {
        Text("\(streak)")
        NavigationSplitView {
            List {
                ForEach(yesterdayHistories) { item in
                    NavigationLink {
                        Text("feeling: \(item.feelingValue.rawValue)")
                    } label: {
                        Text(item.expression)
                    }
                }
                .onDelete { offset in
                    swiftDataManager.deleteHistorys(modelContext: modelContext, offsets: offset, histories: items)
                    setUpStreak()
                }
            }
            .onAppear() {
                checkAndAddHistory()
            }
            .onChange(of: items) {
                updateHistories()
            }
            .onChange(of: currentDateString) {
                checkAndAddHistory()
            }
            .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
                let newDateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
                print(newDateString)
                if newDateString != currentDateString {
                    currentDateString = newDateString
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        swiftDataManager.addHistory(modelContext: modelContext)
                        setUpStreak()
                    } label: {
                        Label("Add History", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}

extension ContentView {
    func updateHistories() {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        todayHistories = items.filter {
            DateFormatter.localizedString(from: $0.date, dateStyle: .short, timeStyle: .none)
            ==
            DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        }
        yesterdayHistories = items.filter {
            DateFormatter.localizedString(from: $0.date, dateStyle: .short, timeStyle: .none)
            ==
            DateFormatter.localizedString(from: yesterday, dateStyle: .short, timeStyle: .none)
        }
    }
    
    func checkAndAddHistory() {
        updateHistories()
        if todayHistories.isEmpty {
            swiftDataManager.addHistory(modelContext: modelContext)
            setUpStreak()
        }
    }
    
    func setUpStreak() {
        if !yesterdayHistories.isEmpty {
            if yesterdayHistories[0].isPerformed {
                streak += 1
            }
            else {
                streak = 0
            }
        }
        else {
            streak = 0
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: History.self, inMemory: true)
        .environment(SwiftDataManager())
}
