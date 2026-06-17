//
//  ContentView.swift
//  SmartCuber
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var solves: [Solve]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(solves) { solve in
                    NavigationLink {
                        SolveDetailView(solve: solve)
                    } label: {
                        SolveRowView(solve: solve)
                    }
                }
                .onDelete(perform: deleteSolves)
            }
            .navigationTitle("Smart Cuber")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addSolve) {
                        Label("Add Solve", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a solve")
        }
    }

    private func addSolve() {
        withAnimation {
            let newSolve = Solve(date: Date(), duration: 0)
            modelContext.insert(newSolve)
        }
    }

    private func deleteSolves(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(solves[index])
            }
        }
    }
}

struct SolveRowView: View {
    let solve: Solve

    var body: some View {
        VStack(alignment: .leading) {
            Text(solve.formattedDuration)
                .font(.headline)
            Text(solve.date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct SolveDetailView: View {
    let solve: Solve

    var body: some View {
        VStack(spacing: 16) {
            Text(solve.formattedDuration)
                .font(.largeTitle.bold())
            Text(solve.date, style: .date)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Solve")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Solve.self, inMemory: true)
}
