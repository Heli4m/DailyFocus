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
                
                Image("layeredWavesbg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(minWidth: 0)
                
                ScrollView {
                    VStack {
                        ForEach(TaskList) { task in
                            Task(width: geometry.size.width - 30, data: task) {
                                selectedTask = task
                                activeState = .openingTask
                            }
                        }
                    }
                }
                
                VStack {
                    NewTaskButton() {
                        activeState = .editingTask
                    }
                    .position(x: geometry.size.width - 75, y: geometry.size.height - 50)
                }
            }
            
            
            .sheet(isPresented: Binding(
                get: { activeState == .editingTask },
                set: { if !$0 { activeState = nil } }
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
                    CountDownTimer(secondsRemaining: task.time * 60) // Convert to seconds
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color(Config.bgColor))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
