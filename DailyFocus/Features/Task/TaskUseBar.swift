//
//  TaskUseBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI

struct TaskUseBar: View {
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
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 3, height: 150)
                        .offset(x: 20)
                        .foregroundStyle(Config.itemColor)
                    
                    Spacer()
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
                            if data.time >= 15 {
                                onSetTime()
                                Haptics.trigger(.medium)
                            } else {
                                onStart()
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

#Preview {
    struct TaskUseBarPreview: View {
        @State var isShowingSetup = false
        
        var body: some View {
            ZStack {
                Color(Config.bgColor).ignoresSafeArea()
                
                TaskUseBar(
                    data: TaskData(
                        name: "Design Prototype",
                        time: 30,
                        priority: 3
                    ),
                    onSetTime: { print("Set time")},
                    onEdit: { print("Edit tapped")},
                    onStart: { print("Start tapped")}
                )
            }
            .frame(height: 300)
        }
    }
    
    return TaskUseBarPreview()
}
