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
    @State private var hasAppeared: Bool = false
    
    @State private var isshowingSetUp: Bool = false
    @State private var temporaryTime: Int = 25
    
    @State private var sparklePulse: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                
                HomeView(
                    geometry: geometry,
                    hasAppeared: $hasAppeared,
                    selectedTask: $selectedTask,
                    activeState: $activeState,
                    deleteTask: deleteTask,
                    TaskList: TaskList
                )
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
                set: { isOpening in
                    if !isOpening {
                        activeState = nil
                        isshowingSetUp = false
                    }
                }
            )) {
                if let _ = selectedTask {
                    TaskUseBar (
                        isshowingSetUp: $isshowingSetUp,

                        onStart: { minutes in
                            temporaryTime = minutes
                            activeState = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                activeState = .runningTask
                                isshowingSetUp = false
                            }
                        },
                        onEdit: {
                            activeState = .editingTask
                        }
                    )
                    .presentationDetents([isshowingSetUp ? .medium : .fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(Config.bgColor))
                }
            }
                        
            .sheet(isPresented: Binding(
                get: { activeState == .runningTask },
                set: { if !$0 { activeState = nil } }
            )) {
                if let task = selectedTask {
                    CountDownTimer(seconds: task.time * 60) // Convert to seconds
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
