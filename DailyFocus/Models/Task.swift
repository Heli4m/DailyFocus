//
//  Task.swift
//  DailyFocus
//
//  Created by Liam Ngo on 21/1/26.
//

import SwiftUI

struct Task: View {
    let width: CGFloat
    let data: TaskData
    
    @State private var isPressed: Bool = false
    var isRunning: Bool = false
    
    var onOpen: () -> Void
    
    var priorityColor: Color {
        switch data.priority {
        case 3: return Config.Colors.highPriority
        case 2: return Config.Colors.mediumPriority
        default: return Config.Colors.accent
        }
    }
    
    var formattedTime: String {
        let hours = data.time / 60
        let minutes = data.time % 60
        
        if hours == 0 {
            return "\(minutes)m"
        } else if minutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }
    
    var body: some View {
        ZStack {
            Button {
                onOpen()
                Haptics.trigger(.light)
                print("\(data.name)")
            } label: {
                RoundedRectangle(cornerRadius: Config.Layout.mainBigCornerRadius)
                    .frame(width: width)
                    .frame(maxHeight: .infinity)
                    .shadow(
                        color: priorityColor.opacity(isPressed ? 0.3 : 0.1),
                        radius: isPressed ? 10 : 5, x: 0, y: 5
                    )
                    .foregroundStyle(Color(Config.Colors.item))
                    .overlay (
                        HStack {
                            VStack (alignment: .leading) {
                                LexendMediumText(text: data.name, size: Config.Layout.standardMediumTextSize)
                                    .foregroundStyle(Config.Colors.primaryText)
                                
                                LexendMediumText(text: formattedTime, size: 15)
                                    .foregroundStyle(Config.Colors.secondaryText)
                            }
                            .padding(.leading, 30)
                            
                            Spacer()
                            
                            VStack {
                                ForEach(0..<data.priority, id: \.self) { amount in
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(priorityColor)
                                }
                            }
                            .padding(.trailing, 30)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                        }
                    )
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .overlay (alignment: .topLeading) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(isRunning ? Config.Colors.inactiveAccent : Config.Colors.item)
                            .padding()
                    }
            }
        }
        .buttonStyle(SquishButtonStyle())
    }
}

struct SquishyButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                   isPressed = newValue
               }
            }
    }
}

#Preview {
    Task(width: 350, data: TaskData(
        name: "Mock Task",
        time: 10,
        priority: 2
    )) {
        print("placehold")
    }
}
