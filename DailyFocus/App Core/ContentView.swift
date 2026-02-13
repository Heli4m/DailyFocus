//
//  ContentView.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

struct ContentView: View {
    @State private var activeState: AppState? = nil
    @State private var TaskList: [TaskData] = []
    @State private var hasAppeared: Bool = false
    
    @State private var selectedTab: TabEnum = .home
    @State private var taskRunning: Bool = false
    
    @State private var selectedMinutes: Int = 25
    @State private var selectedTask: TaskData? = nil
    
    @State private var sparklePulse: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                
                TabView (selection: $selectedTab) {
                    HomeView(
                        geometry: geometry,
                        hasAppeared: $hasAppeared,
                        selectedTask: $selectedTask,
                        activeState: $activeState,
                        deleteTask: deleteTask,
                        TaskList: TaskList
                    )
                    .tag(TabEnum.home)
                    
                    TimerMainContainer(
                        appState: $activeState,
                        selectedMinutes: $selectedMinutes
                    )
                    .tag(TabEnum.timer)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
            }
            
            .sheet(isPresented: Binding(
                get: { activeState == .editingTask },
                set: { if !$0 {
                    selectedTask = nil
                    activeState = nil
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
                set: { if !$0 { activeState = nil }}
            )) {
                if let task = selectedTask {
                    TaskUseBar (
                        data: selectedTask!,

                        onSetTime: {
                            activeState = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                activeState = .settingFocusTime
                            }
                        },
                        onEdit: {
                            activeState = .editingTask
                        },
                        onStart: {
                            selectedTab = .timer
                            selectedMinutes = task.time
                            activeState = .runningTask
                            taskRunning = true
                        }
                    )
                    .presentationDetents([.fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(Config.bgColor))
                }
            }
            
            .sheet(isPresented: Binding(
                get: { activeState == .settingFocusTime },
                set: { if !$0 { activeState = nil }}
            )) {
                if let task = selectedTask {
                    TaskSetTimeBar (
                        selectedMinutes: $selectedMinutes,
                        task: task,
                        
                        onStart: { minutes in
                            selectedTab = .timer
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    activeState = .runningTask
                                }
                            }
                        }
                    )
                    .presentationDetents([.medium])
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
    
    private func goTo (_ next: AppState) {
        withAnimation {
            activeState = next
        }
    }
}

#Preview {
    ContentView()
}
