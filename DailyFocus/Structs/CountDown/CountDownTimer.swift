//
//  CountDownTimer.swift
//  DailyFocus
//
//  Created by Liam Ngo on 24/1/26.
//

import SwiftUI
import Combine
import UserNotifications

struct CountDownTimer: View {
    @State var secondsRemaining: Int
    let totalSeconds: Int
    @State var timerState: TimerStates = .running
    @State var isProcessingATap: Bool = false
    @State private var showConfetti: Bool = false
    
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
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                    .onTapGesture(count: 2) {
                        guard !isProcessingATap else { return }
                        isProcessingATap = true
                        
                        Haptics.trigger(.heavy)
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if timerState == .running {
                                timerState = .paused
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            } else if timerState == .paused {
                                resume()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isProcessingATap = false
                        }
                    }
                
                LexendMediumText(text: timeString, size: 80)
                    .foregroundStyle(Config.primaryText)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(secondsRemaining)))
                    .animation(.snappy, value: secondsRemaining)
                
                ZStack {
                    Circle()
                        .stroke(Config.primaryText.opacity(0.1), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(secondsRemaining) / CGFloat(totalSeconds))
                        .stroke(
                            Color(Config.accentColor),
                            style: StrokeStyle(lineWidth: 10)
                        )
                        .rotationEffect(.degrees(-90)) // Start at the top
                        .animation(.linear(duration: 1), value: secondsRemaining)
                }
                .frame(width: 350, height: 350)
                
                if timerState == .paused {
                    PauseTimer {
                        resume()
                        Haptics.trigger(.light)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                }
                
                if showConfetti {
                    Confetti(containerSize: geometry.size)
                        .ignoresSafeArea()
                        .zIndex(10)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear() {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                scheduleNotification(secondsRemaining: secondsRemaining)
            }
            .onReceive(timer) { _ in
                guard timerState == .running else { return }
                
                if secondsRemaining > 0 {
                    secondsRemaining -= 1
                } else {
                    timerState = .finished
                    withAnimation() {
                        showConfetti = true
                    }
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            }
        }
    }
    
    func resume() {
        timerState = .running
        scheduleNotification(secondsRemaining: secondsRemaining)
    }
}

#Preview {
    CountDownTimer(secondsRemaining: 1, totalSeconds: 1)
}
