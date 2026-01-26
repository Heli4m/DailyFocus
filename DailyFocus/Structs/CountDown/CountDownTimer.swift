//
//  CountDownTimer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI
import Combine

struct CountDownTimer: View {
    @State var secondsRemaining: Int
    @State var isActive: Bool = true
    @State private var showPauseOverlay: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timeString: String {
        let hours = secondsRemaining / 3600
        let minutes = (secondsRemaining % 3600) / 60
        let seconds = secondsRemaining % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    var body: some View {
        ZStack {
            Color(Config.bgColor)
                .ignoresSafeArea()
            
            LexendMediumText(text: timeString, size: 80)
                .foregroundStyle(Config.primaryText)
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(secondsRemaining)))
                .animation(.snappy, value: secondsRemaining)
            
            if showPauseOverlay {
                PauseTimer(isActive: $isActive)
                    .transition(.move(edge: .bottom))
                    .onTapGesture {
                        isActive = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showPauseOverlay = false
                            }
                        }
                    }
            }
        }
        .onReceive(timer) { _ in
            if isActive && secondsRemaining > 0 {
                secondsRemaining -= 1
            } else if secondsRemaining == 0 {
                isActive = false
            }
        }
        .onTapGesture(count: 2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isActive = false
                showPauseOverlay = true
            }
        }
    }
}

#Preview {
    CountDownTimer(secondsRemaining: 3600)
}
