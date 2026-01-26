//
//  PauseTimer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 25/1/26.
//

import SwiftUI

struct PauseTimer: View {
    @Binding var isActive: Bool
    
    // animation variables
    @State private var popScale: CGFloat = 0.8
    @State private var popOpacity: Double = 0.0
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.black.opacity(0.5))
                .ignoresSafeArea()
            
            if !isActive {
                LexendPauseShape()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Config.bgColor)
            }
            
            if isActive {
                LexendPlayShape()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Config.bgColor)
                    .scaleEffect(popScale)
                    .opacity(popOpacity)
                    .onAppear {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                            popScale = 1.0
                            popOpacity = 1.0
                        }
                    }
            }
        }
        .drawingGroup()
        .ignoresSafeArea()
    }
}
