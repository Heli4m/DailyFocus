//
//  TaskUseBar.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI

struct TaskUseBar: View {
    @Binding var isshowingSetUp: Bool
    @State private var selectedMinutes: Int = 25
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
    
    var onStart: (Int) -> Void
    var onEdit: () -> Void
    
    var body: some View {
        ZStack {
            if !isshowingSetUp {
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
                                        .font(Font.system(size: 90))
                                }
                            }
                            
                            
                            Button {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    isshowingSetUp = true
                                }
                            } label: {
                                VStack {
                                    Image(systemName: "play.circle.fill")
                                        .font(Font.system(size: 90))
                                }
                            }
                        }
                        .padding(.trailing, 30)
                        
                    }
                    .padding(.top, 40)
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading).combined(with: .opacity)))
                    
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    LexendMediumText(text: "Choose Duration", size: 24)
                        .foregroundStyle(Config.primaryText)
                        .padding()
                    
                    HStack(spacing: 12) {
                        ForEach([15, 30, 45, 60], id: \.self) { mins in
                            Button {
                                selectedMinutes = mins
                                Haptics.trigger(.light)
                            } label: {
                                LexendMediumText(text: "\(mins)m", size: 16)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedMinutes == mins ? Config.accentColor : Config.itemColor)
                                    .foregroundStyle(selectedMinutes == mins ? .white : Config.primaryText)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        onStart(selectedMinutes)
                    } label: {
                        LexendMediumText(text: "Begin Focus", size: 24)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Config.accentColor)
                            .foregroundStyle(Config.primaryText)
                            .cornerRadius(20)
                    }
                    .padding()
                }
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
                    isshowingSetUp: $isShowingSetup,
                    data: TaskData(
                        name: "Design Prototype",
                        time: 30,
                        priority: 3
                    ),
                    onStart: { mins in print("Started with \(mins) mins") },
                    onEdit: { print("Edit tapped") }
                )
            }
            .frame(height: 300)
        }
    }
    
    return TaskUseBarPreview()
}
