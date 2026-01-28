//
//  TaskEditBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

// TaskEditBar is displayed in .sheet
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
    @State private var selectedPriority: Int = 1
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
    
    var body: some View {
        LexendRegularText(text: "Task Name:", size: 18)
            .foregroundStyle(Color(Config.primaryText))
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

#Preview {
    TaskEditBar { task in
        print("Preview: Created task \(task.name)")
    }
}
