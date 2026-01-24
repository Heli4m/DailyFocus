//
//  TaskEditBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

// TaskEditBar is displayed in .sheet
struct TaskEditBar: View {
    @Environment(\.dismiss) var dismiss // random code to allow button to dismiss the .sheet
    var onCreate: (TaskData) -> Void // the struct's function, can be called upon when the struct is called
    
    // user filled variables
    @State var selectedtaskName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var selectedPriority: Int = 1
    var selectedDuration: Int { // uses some calculation to store duration in minutes
        let hoursToMinutes = hours * 60
        return hoursToMinutes + minutes
    }
    
    // stores color states for the done button
    var doneButtonColor: Color {
        selectedtaskName.isEmpty ? Config.inactiveAccentColor : Config.accentColor
    }
    
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
                        if selectedtaskName != "" {
                            let newTask = TaskData(
                                name: selectedtaskName,
                                time: selectedDuration,
                                priority: selectedPriority
                            ) // creates a new task based on the TaskData struct
                            onCreate(newTask) // shoves the newTask into oncreate function so that it can be processed elsewhere
                            dismiss() // closes the .sheet
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(doneButtonColor)
                            .frame(width: geometry.size.width - 30, height: 40)
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
