//
//  TaskList.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import SwiftUI

struct TaskListView: View {
    let width: CGFloat
    @Binding var hasAppeared: Bool
    let TaskList: [TaskData]
    @Binding var selectedTask: TaskData?
    @Binding var activeState: AppState?
    
    let deleteTask: (_ task: TaskData) -> Void
    
    var body: some View {
        let sortedTasks = TaskList.sorted(by: { $0.priority > $1.priority })
        
        List { // list of tasks
            ForEach(Array(sortedTasks.enumerated()), id: \.element.id) { index, task in
                Task(width: width - 30, data: task) {
                    selectedTask = task
                    activeState = .openingTask
                    print("Task clicked: \(task.name)")
                }
                .contentShape(Rectangle())
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.7)
                    .delay(Double(index) * 0.5),
                    value: hasAppeared
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        hasAppeared = true
                    }
                }
                .frame(height: 100)
                .contextMenu {
                    Button(role: .destructive) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            deleteTask(task)
                        }
                        Haptics.trigger(.rigid)
                    } label: {
                        Label("", systemImage: "trash")
                    }
                }
            }
            .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

