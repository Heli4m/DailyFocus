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
    @Environment(\.scenePhase) var scenePhase
    @State private var lastActiveDate: Date? = nil
    @Binding var appState: AppState?
    
    init(seconds: Int, appState: Binding<AppState?>) {
        _timeModel = State(wrappedValue: TimerViewModel(initialSeconds: seconds))
        _appState = appState
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
                
                TimerCircleView (
                    secondsRemaining: timeModel.secondsRemaining,
                    totalSeconds: timeModel.totalSeconds
                )
                
                TimerStatusOverlay(
                    timeModel: timeModel,
                    containerSize: geometry.size,
                    appState: $appState
                )
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                lastActiveDate = Date()
            } else if newPhase == .active {
                if let lastDate = lastActiveDate, timeModel.timerState == .running {
                    let timePassed = Int(Date().timeIntervalSince(lastDate))
                    
                    withAnimation() {
                        timeModel.secondsRemaining -= timePassed
                    }
                    
                    if timeModel.secondsRemaining < 0 {
                        timeModel.secondsRemaining = 0
                        timeModel.timerState = .finished
                    }
                }
            }
        }
    }
}
