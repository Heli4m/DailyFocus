//
//  TaskEditBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import SwiftUI

struct TaskEditBar: View {
    @State var selectedtaskName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    var selectedDuration: Int {
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        return hoursToSeconds + minutesToSeconds + seconds
    }
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                BasicForm(selectedtaskName: $selectedtaskName)
                
                HStack {
                    HStack {
                        WheelForm(selectedDuration: $hours, range: 0..<24, label: "Hours")
                        WheelForm(selectedDuration: $minutes, range: 0..<60, label: "Minutes")
                        WheelForm(selectedDuration: $seconds, range: 0..<60, label: "Seconds")
                    }
                    .padding()
                }
                .background(Color(Config.itemColor))
                .cornerRadius(15)
                .padding(.top)
            }
            .padding()
        }
    }
}

struct BasicForm: View {
    @Binding var selectedtaskName: String
    
    var body: some View {
        LexendRegularText(text: "Task Name:", size: 18)
            .foregroundStyle(Color(Config.primaryText))
        TextField("New Task", text: $selectedtaskName)
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
            
            LexendRegularText(text: "\(label)", size: 18)
                .foregroundStyle(Config.primaryText)
        }
    }
}
#Preview {
    TaskEditBar()
}
