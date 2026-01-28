//
//  ContentView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

struct ContentView: View {
    @State private var activeState: AppState? = nil
    @State private var selectedTask: TaskData? = nil
    @State private var TaskList: [TaskData] = []
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                
                List {
                    ForEach(TaskList.sorted(by: { $0.priority > $1.priority })) { task in
                        Task(width: geometry.size.width - 30, data: task) {
                            selectedTask = task
                            activeState = .openingTask
                        }
                        .frame(height: 100)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteTask(task)
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
                
                VStack {
                    NewTaskButton() {
                        selectedTask = nil
                        activeState = .editingTask
                    }
                    .position(x: geometry.size.width - 75, y: geometry.size.height - 50)
                }
            }
            
            
            .sheet(isPresented: Binding(
                get: { activeState == .editingTask },
                set: { if !$0 {
                    activeState = nil
                    selectedTask = nil
                } }
            )) {
                TaskEditBar(
                    onCreate: { createdTask in
                        if selectedTask == nil {
                            TaskList.append(createdTask)
                        }
                    },
                    
                    onEdit: { updatedTask in
                        if let index = TaskList.firstIndex(where: { $0.id == updatedTask.id }) {
                            TaskList[index] = updatedTask
                        }
                        selectedTask = nil 
                        activeState = nil
                    },
                    existingTask: selectedTask
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color(Config.bgColor))
            }
            
            .sheet(isPresented: Binding(
                get: { activeState == .openingTask },
                set: { if !$0 { activeState = nil } }
            )) {
                if let _ = selectedTask {
                    TaskUseBar (
                        onStart: {
                            activeState = .runningTask
                        },
                        onEdit: {
                            activeState = .editingTask
                        }
                    )
                    .presentationDetents([.fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(Config.bgColor))
                }
            }
            
            .sheet(isPresented: Binding(
                get: { activeState == .runningTask },
                set: { if !$0 { activeState = nil } }
            )) {
                if let task = selectedTask {
                    CountDownTimer(secondsRemaining: task.time * 60, totalSeconds: task.time * 60) // Convert to seconds
                        .presentationDetents([.large, .medium])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color(Config.bgColor))
                }
            }
        }
        .onChange(of: TaskList) { oldtasks, newtasks in
            saveData(data: newtasks)
        }
        .onAppear() {
            TaskList = loadData()
            requestNotifyPermission()
        }
    }
    
    func deleteTask( _ task: TaskData) {
        if let index = TaskList.firstIndex(where: { $0.id == task.id }) {
            TaskList.remove(at: index)
        }
    }
}

#Preview {
    ContentView()
}
