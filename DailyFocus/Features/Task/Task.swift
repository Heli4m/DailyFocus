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
    
    var isRunning: Bool = false
    
    var onOpen: () -> Void
    
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
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: width)
                    .frame(maxHeight: .infinity)
                    .foregroundStyle(Color(Config.itemColor))
                    .overlay (
                        HStack {
                            VStack (alignment: .leading) {
                                LexendMediumText(text: data.name, size: 20)
                                    .foregroundStyle(Config.primaryText)
                                
                                LexendMediumText(text: formattedTime, size: 15)
                                    .foregroundStyle(Config.secondaryText)
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
                        }
                    )
                    .overlay (alignment: .topLeading) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(isRunning ? Config.inactiveAccentColor : Config.itemColor)
                            .padding()
                    }
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
