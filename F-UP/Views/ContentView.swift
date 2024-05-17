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
    @Query private var items: [History]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("feeling: \(item.feelingValue.rawValue)")
                    } label: {
                        Text(item.expression)
                    }
                }
                .onDelete(perform: deleteHistorys)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addHistory) {
                        Label("Add History", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addHistory() {
        withAnimation {
            guard let audioURL = URL(string: "https://www.example.com")
            else {
                print("Invalid URL")
                return
            }
            
            let newHistory = History(
                date: Date(),
                isPerformed: false,
                challengeStep: .notStarted,
                expression: "Test Expression",
                audioURL: audioURL,
                target: .family,
                specificTarget: nil,
                feelingValue: .veryComfortable,
                reactionValue: .veryGood
            )
            modelContext.insert(newHistory)
        }
    }

    private func deleteHistorys(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: History.self, inMemory: true)
}
