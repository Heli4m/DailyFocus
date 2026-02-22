// Created by Liam Ngo on 18/1/26.
// Purpose: The backbone of the app, puts all the views and computing together.

import SwiftUI

struct ContentView: View {
    /// activeState holds the current state of the app through the AppState enum, which determines .sheets and timers.
    @State private var activeState: AppState? = nil
    /// TaskList holds the list of all the tasks that have been created as well as all of its data based on TaskData struct.
    @State private var TaskList: [TaskData] = []
    /// hasAppeared holds the boolean to determine the appearance of TaskList
    @State private var hasAppeared: Bool = false
    /// selectedTab holds the current tab that the user is on, also updates TabsBar
    @State private var selectedTab: TabEnum = .home
    /// timeModel stores the calculations related to time. secondsRemaining is most used.
    @State private var timeModel = TimerViewModel(initialSeconds: 0)
    /// completionPage holds rhe current TaskCompleteView and displays them in order
    @State private var completionPage: TaskCompletePages? = nil
    
    @State private var pauseCount: Int = 0
    
    @State private var selectedMinutes: Int = 25
    @State private var selectedTask: TaskData? = nil
    @State private var currentTimerTask: TaskData? = nil
    
    @State private var sparklePulse: Bool = false
    
    /// Checks for when to show and hide TabsBar
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
    
    /// This function searches for an item where id matches task.id and removes it from TaskList.
     private func deleteTask( _ task: TaskData) {
        if let index = TaskList.firstIndex(where: { $0.id == task.id }) {
            TaskList.remove(at: index)
        }
    }
    
    /// This function changes active state to a chosen state with animation.
    private func goTo (_ next: AppState) {
        withAnimation {
            activeState = next
        }
    }
}

#Preview {
    ContentView()
}
