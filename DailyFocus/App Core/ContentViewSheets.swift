//
//  ContentViewSheets.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/2/26.
//

import Foundation
import SwiftUI

extension View {
    func AppTaskSheets (
        activeState: Binding<AppState?>,
        selectedTask: Binding<TaskData?>,
        selectedMinutes: Binding<Int>,
        TaskList: Binding<[TaskData]>,
        timeModel: TimerViewModel,
        selectedTab: Binding<TabEnum>
    ) -> some View {
        self
            // EDIT SHEET
            .sheet(isPresented: Binding(
                get: { activeState.wrappedValue == .editingTask },
                set: { if !$0 {
                    selectedTask.wrappedValue = nil
                    activeState.wrappedValue = nil
                } }
            )) {
                TaskEditBar(
                    onCreate: { createdTask in
                        if selectedTask.wrappedValue == nil {
                            TaskList.wrappedValue.append(createdTask)
                        }
                    },
                    
                    onEdit: { updatedTask in
                        if let index = TaskList.firstIndex(where: { $0.id == updatedTask.id }) {
                            TaskList.wrappedValue[index] = updatedTask
                        }
                        selectedTask.wrappedValue = nil
                        activeState.wrappedValue = nil
                    },
                    existingTask: selectedTask.wrappedValue
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color(Config.Colors.background))
            }
            
            // USE BAR SHEET
            .sheet(isPresented: Binding(
                get: { activeState.wrappedValue == .openingTask },
                set: { if !$0 { activeState.wrappedValue = nil }}
            )) {
                if let _ = selectedTask.wrappedValue {
                    TaskUseBar (
                        data: selectedTask.wrappedValue!,

                        onSetTime: {
                            activeState.wrappedValue = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                activeState.wrappedValue = .settingFocusTime
                            }
                        },
                        onEdit: {
                            activeState.wrappedValue = .editingTask
                        },
                        onStart: {
                            startTimerLogic (
                                minutes: selectedMinutes.wrappedValue,
                                timeModel: timeModel,
                                selectedTab: selectedTab,
                                activeState: activeState
                            )
                        }
                    )
                    .presentationDetents([.fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(Config.Colors.background))
                }
            }
            
            // SET TIME SHEET
            .sheet(isPresented: Binding(
                get: { activeState.wrappedValue == .settingFocusTime },
                set: { if !$0 { activeState.wrappedValue = nil }}
            )) {
                if let task = selectedTask.wrappedValue {
                    TaskSetTimeBar (
                        selectedMinutes: selectedMinutes,
                        task: task,
                        
                        onStart: { minutes in
                            selectedMinutes.wrappedValue = minutes
                            startTimerLogic (
                                minutes: minutes,
                                timeModel: timeModel,
                                selectedTab: selectedTab,
                                activeState: activeState
                            )
                        }
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(Config.Colors.background))
                }
            }
    }
    
    private func startTimerLogic(minutes: Int, timeModel: TimerViewModel, selectedTab: Binding<TabEnum>, activeState: Binding<AppState?>) {
        let totalSeconds = minutes * 60
            timeModel.secondsRemaining = totalSeconds
            timeModel.totalSeconds = totalSeconds
            timeModel.timerState = .running
        
        withAnimation { selectedTab.wrappedValue = .timer }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { activeState.wrappedValue = .runningTask }
        }
    }
}
