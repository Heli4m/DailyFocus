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
    @State private var timeModel = TimerViewModel(initialSeconds: 0)
    
    @State private var pauseCount: Int = 0
    
    @State private var selectedMinutes: Int = 25
    @State private var selectedTask: TaskData? = nil
    
    @State private var sparklePulse: Bool = false
    
    private var isShowingTabBar: Bool {
        !(selectedTab == .timer && activeState == .runningTask)
    }
    
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
                        selectedMinutes: $selectedMinutes,
                        pauseCount: $pauseCount,
                        timerModel: $timeModel
                    )
                    .tag(TabEnum.timer)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .disabled(activeState == .finishingTask)
                

                if isShowingTabBar {
                    TabsBar(currentTab: $selectedTab, geometry: geometry)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            
                if activeState == .finishingTask {
                    if let selectedTask = selectedTask {
                        let totalTime = Double(selectedTask.time)
                        let minutesRemaining = Double(timeModel.secondsRemaining) / Double(60)
                        let completedTime = Double(selectedMinutes) - minutesRemaining
                        let percentage = Int(totalTime == 0 ? 0 : (completedTime / totalTime) * 100)

                        TaskComplete (
                            completedMinutes: Int(completedTime),
                            pauseCount: pauseCount,
                            completionPercentage: percentage,
                            onContinue: {
                                activeState = nil
                                pauseCount = 0
                                timeModel = TimerViewModel(initialSeconds: 0)
                                
                                withAnimation {
                                    selectedTab = .home
                                }
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(10)
                    }
                }
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
                            let totalSeconds = selectedMinutes * 60
                                timeModel.secondsRemaining = totalSeconds
                                timeModel.totalSeconds = totalSeconds
                                timeModel.timerState = .running
                            
                            withAnimation {
                                selectedTab = .timer
                            }
                            selectedMinutes = task.time
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    activeState = .runningTask
                                }
                            }
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
                            let totalSeconds = selectedMinutes * 60
                            selectedMinutes = minutes
                                timeModel.secondsRemaining = totalSeconds
                                timeModel.totalSeconds = totalSeconds
                                timeModel.timerState = .running
                            
                            withAnimation {
                                selectedTab = .timer
                            }
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
