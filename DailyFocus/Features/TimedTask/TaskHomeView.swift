//
//  HomeView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import SwiftUI

struct TaskHomeView: View {
    let geometry: GeometryProxy
    @Binding var hasAppeared: Bool
    @Binding var selectedTask: TaskData?
    @Binding var activeState: AppState?
    let deleteTask: (TaskData) -> Void
    let TaskList: [TaskData]
    
    var body: some View {
        ZStack {
            if TaskList.isEmpty {
                EmptyTaskList(sparklePulse: true)
            } else {
                TaskListView(
                    width: geometry.size.width,
                    hasAppeared: $hasAppeared,
                    TaskList: TaskList,
                    selectedTask: $selectedTask,
                    activeState: $activeState,
                    deleteTask: deleteTask
                )
            }
            
            NewTaskButton() { // the '+' button
                selectedTask = nil
                activeState = .editingTask
            }
            .position(x: geometry.size.width - 75, y: geometry.size.height - 90)
        }
    }
}

#Preview {
    GeometryReader { geometry in
        TaskHomeView(
            geometry: geometry,
            hasAppeared: .constant(true),
            selectedTask: .constant(nil),
            activeState: .constant(nil),
            deleteTask: { _ in },
            TaskList: [
                TaskData(name: "Sample Task", time: 25, priority: 1),
                TaskData(name: "Refactor Code", time: 60, priority: 2)
            ]
        )
    }
}
