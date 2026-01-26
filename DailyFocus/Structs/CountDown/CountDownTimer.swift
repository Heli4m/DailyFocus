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
    @State var timerState: TimerStates = .running
    
    var isRunning: Bool {
        timerState == .running
    }
    
    var showPausedOverlay: Bool {
        timerState == .paused
    }
    
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
            
            if timerState == .paused {
                PauseTimer {
                    resume()
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    )
                )
            }
        }
        .onReceive(timer) { _ in
            guard timerState == .running else { return }
            
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timerState = .finished
            }
        }
        .onTapGesture(count: 2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                timerState = .paused
            }
        }
    }
    
    func resume() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            timerState = .running
        }
    }
}

#Preview {
    CountDownTimer(secondsRemaining: 3600)
}
