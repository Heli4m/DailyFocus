//
//  TaskViews.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/2/26.
//

import Foundation
import SwiftUI

struct NewTaskButton: View {
    let action: () -> Void
    
    @State private var rotation: Double = 0
    
    var body: some View {
        Button {
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                rotation += 1440
            }
            
            action()
        } label: {
            ZStack {
                Circle()
                    .stroke(Color(Config.itemColor.opacity(0.5)), lineWidth: 4)
                    .frame(width: 82, height: 82)
                
                Circle()
                    .fill(Config.accentColor)
                    .frame(width: 75, height: 75)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
                
                Cross()
                    .rotationEffect(.degrees(rotation))
            }
        }
        .buttonStyle(SquishButtonStyle())
    }
}


struct TaskSetTimeBar: View {
    @Environment(\.dismiss) var dismiss
    @Namespace private var animation
    @Binding var selectedMinutes: Int
    let task: TaskData
    let timeList = [15, 30, 45, 60]
    
    var onStart: (Int) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            LexendMediumText(text: "Choose Duration", size: 24)
                .foregroundStyle(Config.primaryText)
                .padding()
            
            HStack (spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Config.itemColor)
                        .frame(width: 290, height: 60)
                    
                    HStack (alignment: .center, spacing: 0) {
                        ForEach(timeList, id: \.self) { time in
                            Button {
                                withAnimation {
                                    selectedMinutes = time
                                }
                                Haptics.trigger(.light)
                            } label: {
                                ZStack {
                                    Color.clear
                                    LexendMediumText(text: "\(time)", size: 20)
                                        .foregroundStyle(Config.primaryText)
                                }
                                .frame(width: 65, height: 70)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .background {
                                if selectedMinutes == time {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Config.secondaryText)
                                        .frame(width: 60, height: 40)
                                        .padding()
                                        .matchedGeometryEffect(id: "slider", in: animation)
                                }
                            }
                            .disabled(task.time < time ? true : false)
                            
                        }
                    }
                }
                .padding(.leading, 20)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Config.itemColor)
                        .frame(width: 70, height: 60)
                    
                    Button {
                        withAnimation {
                            selectedMinutes = task.time
                        }
                        Haptics.trigger(.light)
                    } label: {
                        ZStack {
                            Color.clear
                            LexendMediumText(text: "\(task.time)", size: 20)
                                .foregroundStyle(timeList.contains(task.time) ? Config.accentColor : Config.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selectedMinutes == task.time && !timeList.contains(task.time) {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Config.secondaryText)
                                .frame(width: 60, height: 40)
                                .padding()
                                .matchedGeometryEffect(id: "slider", in: animation)
                        }
                    }
                }
                .padding(.trailing, 10)
                .padding(.leading, 5)
            }
            
            Spacer()
            
            Button {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onStart(selectedMinutes)
                }
            } label: {
                LexendMediumText(text: "Begin Focus", size: 24)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Config.accentColor)
                    .foregroundStyle(Config.primaryText)
                    .cornerRadius(20)
            }
            .padding()
        }    }
}

struct TaskUseBar: View {
    @Environment(\.dismiss) var dismiss
    let data: TaskData
    
    var priorityColor: Color {
        switch data.priority {
        case 3:
            return Config.highPriority
        case 2:
            return Config.mediumPriority
        default:
            return Config.accentColor
        }
    }
    
    var onSetTime: () -> Void
    var onEdit: () -> Void
    var onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color(Config.bgColor).ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack {
                        ForEach(0..<data.priority, id: \.self) { priority in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(priorityColor)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                    }
                    .padding(.leading)
                    
                    LexendMediumText(text: data.name, size: 30)
                        .foregroundStyle(Config.primaryText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .layoutPriority(1)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 3, height: 150)
                        .padding(.trailing, 20)
                        .foregroundStyle(Config.itemColor)
                    
                    VStack {
                        Button {
                            onEdit()
                        } label: {
                            VStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(Font.system(size: 80))
                            }
                        }
                        
                        
                        Button {
                            if data.time > 15 {
                                onSetTime()
                                Haptics.trigger(.medium)
                            } else {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    onStart()
                                }
                                Haptics.trigger(.medium)
                            }
                        } label: {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(Font.system(size: 80))
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                }
                .padding(.top, 40)
                .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading).combined(with: .opacity)))
                
                Spacer()
            }
        }
    }
}

struct TaskEditBar: View {
    
    // VARIABLES & INIT
    @Environment(\.dismiss) var dismiss // allows the code to dismiss .sheet
    var onCreate: (TaskData) -> Void // function that can have code put in after, for task creation
    var onEdit: ((TaskData) -> Void)? = nil // for task editing
    var existingTask: TaskData? = nil
    
    // stores color states for the done button
    var doneButtonColor: Color {
        (selectedtaskName.isEmpty || selectedDuration == 0) ? Config.inactiveAccentColor : Config.accentColor
    }
    
    // user filled variables
    @State var selectedtaskName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var selectedPriority: Int
    var selectedDuration: Int { // uses some calculation to store duration in minutes
        let hoursToMinutes = hours * 60
        return hoursToMinutes + minutes
    }
    
    // custom init to fill in after edit
    init(
        onCreate: @escaping (TaskData) -> Void,
        onEdit: ((TaskData) -> Void)? = nil,
        existingTask: TaskData? = nil
    ) {
        self.onEdit = onEdit
        self.onCreate = onCreate
        self.existingTask = existingTask
        
        _selectedtaskName = State(initialValue: existingTask?.name ?? "")
        _hours = State(initialValue: (existingTask?.time ?? 0) / 60)
        _minutes = State(initialValue: (existingTask?.time ?? 0) % 60)
        _selectedPriority = State(initialValue: existingTask?.priority ?? 1)
    }
    
    // MAIN VIEW
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack (alignment: .leading) {
                    Spacer()
                    BasicForm(selectedtaskName: $selectedtaskName)
                    
                    HStack {
                        HStack {
                            WheelForm(selectedDuration: $hours, range: 0..<24, label: "Hours")
                            LexendMediumText(text: ":", size: 18)
                                .foregroundStyle(Config.accentColor)
                            WheelForm(selectedDuration: $minutes, range: 0..<60, label: "Minutes")
                        }
                        .padding()
                    }
                    .background(Color(Config.itemColor))
                    .cornerRadius(15)
                    .padding(.top)
                    
                    VStack (alignment: .leading) {
                        LexendRegularText(text: "Priority Level", size: 18)
                            .foregroundStyle(Color(Config.primaryText))
                        PriorityDotMainView(selectedButton: $selectedPriority)
                            .cornerRadius(15)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    Button { // done button
                        if !selectedtaskName.isEmpty && selectedDuration > 0 {
                            if let existingTask = existingTask {
                                let updatedTask = TaskData(
                                    id: existingTask.id,
                                    name: selectedtaskName,
                                    time: selectedDuration,
                                    priority: selectedPriority
                                )
                                onEdit?(updatedTask)
                                Haptics.success()
                            } else {
                                let newTask = TaskData(
                                    name: selectedtaskName,
                                    time: selectedDuration,
                                    priority: selectedPriority
                                ) // creates a new task based on the TaskData struct
                                onCreate(newTask) // shoves the newTask into oncreate function so that it can be processed elsewhere
                                Haptics.success()
                            }
                            dismiss() // closes the .sheet
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(doneButtonColor)
                            .frame(width: max(0, geometry.size.width - 30), height: 40)
                            .overlay {
                                LexendMediumText(text: "Done", size: 18)
                                    .foregroundStyle(Color(Config.primaryText))
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct BasicForm: View {
    @Binding var selectedtaskName: String
    var textLimit: Int = 30
    
    var body: some View {
        HStack {
            LexendRegularText(text: "Task Name:", size: 18)
                .foregroundStyle(Color(Config.primaryText))
            
            Spacer()
            
            LexendRegularText(text: "\(selectedtaskName.count)/\(textLimit)", size: 18)
                .foregroundStyle(selectedtaskName.count == textLimit ? Config.highPriority : Config.secondaryText)
        }
        TextField(
            text: $selectedtaskName,
            prompt: Text("New Task")
                .foregroundStyle(Config.accentColor.opacity(0.2))
        ) {
            Text("Task Name")
        }
            .frame(height: 50)
            .font(Font.custom("Lexend-Regular", size: 18))
            .padding(.horizontal)
            .background(Color(Config.itemColor))
            .foregroundStyle(Config.accentColor)
            .cornerRadius(15)
            .onChange(of: selectedtaskName) {
                if selectedtaskName.count > textLimit {
                    selectedtaskName = String(selectedtaskName.prefix(textLimit))
                    Haptics.warning()
                }
            }
    }
}

struct WheelForm: View {
    @Binding var selectedDuration: Int
    let range: Range<Int>
    let label: String
    
    var body: some View {
        VStack {
            Picker(label, selection: $selectedDuration) {
                ForEach (range, id: \.self) { duration in
                    LexendRegularText(text: "\(duration)", size: 18)
                        .foregroundStyle(Color(Config.accentColor))
                        .tag(duration)
                }
            }
            .pickerStyle(.wheel)
            
            LexendMediumText(text: label, size: 18)
                .foregroundStyle(Config.primaryText)
        }
    }
}

struct TaskData: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let time: Int
    let priority: Int
    
    init(id: UUID = UUID(), name: String, time: Int, priority: Int) {
        self.id = id
        self.name = name
        self.time = time
        self.priority = priority
    }
}
