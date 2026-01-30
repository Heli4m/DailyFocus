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
    @State private var timeModel: TimerViewModel
    
    init(seconds: Int) {
        _timeModel = State(wrappedValue: TimerViewModel(initialSeconds: seconds))
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(Config.bgColor)
                    .ignoresSafeArea()
                    .onTapGesture(count: 2) {
                        guard !timeModel.isProcessingATap else { return }
                        timeModel.isProcessingATap = true
                        
                        Haptics.trigger(.heavy)
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if timeModel.timerState == .running {
                                timeModel.timerState = .paused
                                timeModel.notifications.cancelNotifications()
                            } else if timeModel.timerState == .paused {
                                timeModel.resume()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            timeModel.isProcessingATap = false
                        }
                    }
                
                LexendMediumText(text: timeModel.timeString, size: 80)
                    .foregroundStyle(Config.primaryText)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(timeModel.secondsRemaining)))
                    .animation(.snappy, value: timeModel.secondsRemaining)
                
                ZStack {
                    Circle()
                        .stroke(Config.primaryText.opacity(0.1), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeModel.secondsRemaining) / CGFloat(timeModel.totalSeconds))
                        .stroke(
                            Color(Config.accentColor),
                            style: StrokeStyle(lineWidth: 10)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeModel.secondsRemaining)
                }
                .frame(width: 350, height: 350)
                
                if timeModel.timerState == .paused {
                    PauseTimer {
                        timeModel.resume()
                        Haptics.trigger(.light)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                }
                
                if timeModel.showConfetti {
                    Confetti(containerSize: geometry.size)
                        .ignoresSafeArea()
                        .zIndex(10)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear() {
                timeModel.notifications.cancelNotifications()
                timeModel.notifications.scheduleNotification(secondsRemaining: timeModel.secondsRemaining)
            }
            .onReceive(timer) { _ in
                timeModel.tic()
            }
        }
    }
}

#Preview {
    CountDownTimer(seconds: 1)
}
