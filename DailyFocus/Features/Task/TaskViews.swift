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
                rotation += Config.Time.addButtonSpin
            }
            
            action()
        } label: {
            ZStack {
                Circle()
                    .stroke(Color(Config.Colors.item.opacity(0.5)), lineWidth: 4)
                    .frame(width: Config.Layout.addButtonSizeExternal, height: Config.Layout.addButtonSizeExternal)
                
                Circle()
                    .fill(Config.Colors.accent)
                    .frame(width: Config.Layout.addButtonSizeInternal, height: Config.Layout.addButtonSizeInternal)
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
    
    var onStart: (Int) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            LexendMediumText(text: "Choose Duration", size: Config.Layout.standardTitleTextSize)
                .foregroundStyle(Config.Colors.primaryText)
                .padding()
            
            HStack (spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                        .fill(Config.Colors.item)
                        .frame(width: Config.Layout.bgtimePickerWidth, height: Config.Layout.bgtimePickerHeight)
                    
                    HStack (alignment: .center, spacing: 0) {
                        ForEach(Config.Defaults.timeSelections, id: \.self) { time in
                            Button {
                                withAnimation {
                                    selectedMinutes = time
                                }
                                Haptics.trigger(.light)
                            } label: {
                                ZStack {
                                    Color.clear
                                    LexendMediumText(text: "\(time)", size: Config.Layout.pickerTextSize)
                                        .foregroundStyle(Config.Colors.primaryText)
                                }
                                .frame(width: Config.Layout.timePickerIndividualWidth, height: Config.Layout.timePickerIndividualHeight)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .background {
                                if selectedMinutes == time {
                                    RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                                        .fill(Config.Colors.secondaryText)
                                        .frame(width: Config.Layout.timePickerSliderWidth, height: Config.Layout.timePickerSliderHeight)
                                        .padding()
                                        .matchedGeometryEffect(id: "slider", in: animation)
                                }
                            }
                            .disabled(task.time < time ? true : false)
                            
                        }
                    }
                }
                .padding(.leading, Config.Layout.standardPaddingLarge)
                
                ZStack {
                    RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                        .fill(Config.Colors.item)
                        .frame(width: Config.Layout.customTimeBoxWidth, height: Config.Layout.customTimeBoxHeight)
                    
                    Button {
                        withAnimation {
                            selectedMinutes = task.time
                        }
                        Haptics.trigger(.light)
                    } label: {
                        ZStack {
                            Color.clear
                            LexendMediumText(text: "\(task.time)", size: Config.Layout.pickerTextSize)
                                .foregroundStyle(Config.Defaults.timeSelections.contains(task.time) ? Config.Colors.accent : Config.Colors.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selectedMinutes == task.time && !Config.Defaults.timeSelections.contains(task.time) {
                            RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                                .fill(Config.Colors.secondaryText)
                                .frame(width: 60, height: 40)
                                .padding()
                                .matchedGeometryEffect(id: "slider", in: animation)
                        }
                    }
                }
                .padding(.trailing, Config.Layout.standardPaddingMedium)
                .padding(.leading, Config.Layout.standardPaddingSmall)
            }
            
            Spacer()
            
            Button {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + Config.Time.standardTransitionSpeed) {
                    onStart(selectedMinutes)
                }
            } label: {
                LexendMediumText(text: "Begin Focus", size: Config.Layout.standardTitleTextSize)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Config.Colors.accent)
                    .foregroundStyle(Config.Colors.primaryText)
                    .cornerRadius(Config.Layout.mainBigCornerRadius)
            }
            .padding()
        }    }
}

struct TaskUseBar: View {
    @Environment(\.dismiss) var dismiss
    let data: TaskData
    
    var onSetTime: () -> Void
    var onEdit: () -> Void
    var onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color(Config.Colors.background).ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack {
                        ForEach(0..<data.priority, id: \.self) { priority in
                            Circle()
                                .frame(width: Config.Layout.priorityDotSize, height: Config.Layout.priorityDotSize)
                                .foregroundStyle(data.priorityColor)
                                .padding(.horizontal)
                                .padding(.vertical, Config.Layout.standardPaddingSmall)
                        }
                    }
                    .padding(.leading)
                    
                    LexendMediumText(text: data.name, size: 30)
                        .foregroundStyle(Config.Colors.primaryText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .layoutPriority(1)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: Config.Layout.dividerWidth, height: Config.Layout.dividerHeight)
                        .padding(.trailing, Config.Layout.standardPaddingLarge)
                        .foregroundStyle(Config.Colors.item)
                    
                    VStack {
                        Button {
                            onEdit()
                        } label: {
                            VStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(Font.system(size: Config.Layout.iconButtonSize))
                            }
                        }
                        
                        
                        Button {
                            if data.time > Config.Limits.quickStartMax {
                                onSetTime()
                                Haptics.trigger(.medium)
                            } else {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + Config.Time.standardTransitionSpeed) {
                                    onStart()
                                }
                                Haptics.trigger(.medium)
                            }
                        } label: {
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(Font.system(size: Config.Layout.iconButtonSize))
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                }
                .padding(.top, Config.Layout.standardPaddingExtraLarge)
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
        (selectedtaskName.isEmpty || selectedDuration == 0) ? Config.Colors.inactiveAccent : Config.Colors.accent
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
                            WheelForm(selectedDuration: $hours, range: 0..<Config.Limits.maxHours, label: "Hours")
                            LexendMediumText(text: ":", size: Config.Layout.standardSmallTextSize)
                                .foregroundStyle(Config.Colors.accent)
                            WheelForm(selectedDuration: $minutes, range: 0..<Config.Limits.maxMinutes, label: "Minutes")
                        }
                        .padding()
                    }
                    .background(Color(Config.Colors.item))
                    .cornerRadius(Config.Layout.mainCornerRadius)
                    .padding(.top)
                    
                    VStack (alignment: .leading) {
                        LexendRegularText(text: "Priority Level", size: Config.Layout.standardSmallTextSize)
                            .foregroundStyle(Color(Config.Colors.primaryText))
                        PriorityDotMainView(selectedButton: $selectedPriority)
                            .cornerRadius(Config.Layout.mainCornerRadius)
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
                        RoundedRectangle(cornerRadius: Config.Layout.mainCornerRadius)
                            .foregroundStyle(doneButtonColor)
                            .frame(width: max(0, geometry.size.width - 30), height: 40)
                            .overlay {
                                LexendMediumText(text: "Done", size: Config.Layout.standardSmallTextSize)
                                    .foregroundStyle(Color(Config.Colors.primaryText))
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
    var textLimit: Int = Config.Limits.taskNameMax
    
    var body: some View {
        HStack {
            LexendRegularText(text: "Task Name:", size: Config.Layout.standardSmallTextSize)
                .foregroundStyle(Color(Config.Colors.primaryText))
            
            Spacer()
            
            LexendRegularText(text: "\(selectedtaskName.count)/\(textLimit)", size: Config.Layout.standardSmallTextSize)
                .foregroundStyle(selectedtaskName.count == textLimit ? Config.Colors.highPriority : Config.Colors.secondaryText)
        }
        TextField(
            text: $selectedtaskName,
            prompt: Text("New Task")
                .foregroundStyle(Config.Colors.accent.opacity(0.2))
        ) {
            Text("Task Name")
        }
            .frame(height: 50)
            .font(Font.custom("Lexend-Regular", size: Config.Layout.standardSmallTextSize))
            .padding(.horizontal)
            .background(Color(Config.Colors.item))
            .foregroundStyle(Config.Colors.accent)
            .cornerRadius(Config.Layout.mainCornerRadius)
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
                    LexendRegularText(text: "\(duration)", size: Config.Layout.standardSmallTextSize)
                        .foregroundStyle(Color(Config.Colors.accent))
                        .tag(duration)
                }
            }
            .pickerStyle(.wheel)
            
            LexendMediumText(text: label, size: Config.Layout.standardSmallTextSize)
                .foregroundStyle(Config.Colors.primaryText)
        }
    }
}
