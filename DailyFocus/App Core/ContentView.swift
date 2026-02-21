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
    @State private var completionPage: TaskCompletePages? = nil
    
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
                Color(Config.Colors.background)
                    .ignoresSafeArea()
                
                TabView (selection: $selectedTab) {
                    HomeView()
                        .tag(TabEnum.home)
                    
                    ChecklistTask()
                        .tag(TabEnum.checklist)
                    
                    TaskHomeView(
                        geometry: geometry,
                        hasAppeared: $hasAppeared,
                        selectedTask: $selectedTask,
                        activeState: $activeState,
                        deleteTask: deleteTask,
                        TaskList: TaskList
                    )
                    .tag(TabEnum.timedtasks)
                    
                    TimerMainContainer(
                        appState: $activeState,
                        selectedMinutes: $selectedMinutes,
                        pauseCount: $pauseCount,
                        timerModel: $timeModel,
                        completionPages: $completionPage
                    )
                    .tag(TabEnum.timer)
                    
                    SettingsView()
                        .tag(TabEnum.settings)

                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .disabled(activeState == .finishingTask)
                

                if isShowingTabBar {
                    TabsBar(currentTab: $selectedTab, geometry: geometry)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                if completionPage == .summary {
                    if let selectedTask = selectedTask {
                        let percentage = timeModel.calculateCompletionPercentage(sessionTotal: selectedMinutes, goalTotal: selectedTask.time)
                        let completedTime = timeModel.calculateCompletedTime(sessionTotal: selectedMinutes)
                        
                        TaskComplete (
                            completedMinutes: completedTime,
                            pauseCount: pauseCount,
                            completionPercentage: percentage,
                            onContinue: {
                                activeState = nil
                                pauseCount = 0
                                timeModel = TimerViewModel(initialSeconds: 0)
                                
                                completionPage = .highlight
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(10)
                    }
                }
                
                if completionPage == .highlight {
                    if let selectedTask = selectedTask {
                        TaskCompleteHighlight(
                            totalTaskTime: selectedMinutes,
                            completedTaskTime: selectedMinutes - timeModel.secondsRemaining,
                            taskPriority: selectedTask.priority,
                            pauseCount: pauseCount,
                            geometry: geometry,
                            onContinue: {
                                completionPage = nil
                                withAnimation {
                                    selectedTab = .timedtasks
                                }
                            }
                        )
                    }
                }
            }
            .AppTaskSheets(
                activeState: $activeState,
                selectedTask: $selectedTask,
                selectedMinutes: $selectedMinutes,
                TaskList: $TaskList,
                timeModel: timeModel,
                selectedTab: $selectedTab
            )
           
        }
        .onChange(of: TaskList) { oldtasks, newtasks in
            saveData(data: newtasks)
        }
        .onAppear() {
            TaskList = loadData()
            requestNotifyPermission()
        }
    }
    
    private func deleteTask( _ task: TaskData) {
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
