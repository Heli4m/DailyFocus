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
    
    @State private var sparklePulse: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                
                if TaskList.isEmpty {
                    VStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 80))
                            .foregroundStyle(Config.accentColor)
                            .padding(.bottom)
                            .scaleEffect(sparklePulse ? 1.1 : 1)
                            .opacity(sparklePulse ? 1 : 0.7)
                            .animation (
                                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: sparklePulse
                            )
                            .onAppear {
                                sparklePulse = true
                            }
                            
                        
                        LexendMediumText(text: "Tap the '+' to add your first focus app!", size: 28)
                            .foregroundStyle(Config.primaryText)
                            .monospacedDigit()
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                } else {
                    let sortedTasks = TaskList.sorted(by: { $0.priority > $1.priority })
                    List {
                        ForEach(Array(sortedTasks.enumerated()), id: \.element.id) { index, task in
                            Task(width: geometry.size.width - 30, data: task) {
                                selectedTask = task
                                activeState = .openingTask
                            }
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
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteTask(task)
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
