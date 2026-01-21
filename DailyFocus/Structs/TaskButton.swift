//
//  TaskButton.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

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
        .buttonStyle(.plain)
    }
}
