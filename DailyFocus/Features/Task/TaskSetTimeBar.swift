//
//  TaskSetTimeBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 3/2/26.
//

import SwiftUI

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
                                .foregroundStyle(Config.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selectedMinutes == task.time {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Config.secondaryText)
                                .frame(width: 60, height: 40)
                                .padding()
                                .matchedGeometryEffect(id: "slider", in: animation)
                        }
                    }
                }
                .padding(.trailing, 10)
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

#Preview {
    TaskSetTimeBar(
        selectedMinutes: .constant(25),
        task: TaskData(
            name: "Mock Task",
            time: 61,
            priority: 2
        ),
        onStart: { mins in print("Started with \(mins) mins") }
    )
}
